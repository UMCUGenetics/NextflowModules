
process CollectWGSMetrics {
  tag {"GATK CollectWGSMetrics ${sample_id}"}
  label 'GATK_4_1_3_0'
  label 'GATK_4_1_3_0_CollectWGSMetrics'
  clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
  container = 'library://sawibo/default/bioinf-tools:gatk4.1.3.0'
  shell = ['/bin/bash', '-euo', 'pipefail']
  input:
    tuple (sample_id, path(bam))

  output:
    path ("${sample_id}.wgs_metrics.txt" , emit: wgs_metrics)

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
