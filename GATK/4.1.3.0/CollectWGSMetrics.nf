
process CollectWGSMetrics {
  tag {"GATK_Collectwgsmetrics ${sample_id}"}
  label 'GATK_4_1_3_0'
  label 'GATK_4_1_3_0_Collectwgsmetrics'
  clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.collectwgsmetric.mem}" : ""
  container = 'library://sawibo/default/bioinf-tools:gatk4.1.3.0'

  input:
    tuple sample_id, file(bam)

  output:
    file ("${sample_id}.wgs_metrics.txt")

  script:
  """
  gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
  CollectWgsMetrics \
  -I $bam \
  -O ${sample_id}.wgs_metrics.txt \
  -R ${params.genome_fasta} \
  ${params.optional}
  sed -i 's/picard\\.analysis\\.WgsMetrics/picard\\.analysis\\.CollectWgsMetrics\\\$WgsMetrics/' ${sample_id}.wgs_metrics.txt
  """
}
