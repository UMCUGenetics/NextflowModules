
process CollectWGSMetrics {
  tag {"GATK_collectwgsmetrics ${sample_id}"}
  label 'GATK_4_1_3_0'
  label 'GATK_collectwgsmetrics_4_1_3_0'
  clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.collectwgsmetrics.mem}" : ""

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
  -R $params.genome_fasta \
  """
}
