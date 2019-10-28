
process CollectWGSMetrics {
  tag {"CollectWGSMetrics ${sample_id}"}
  label 'GATK'
  clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.collectwgsmetrics_mem}" : ""
  publishDir "$params.out_dir/$sample_id/wgs_metrics", mode: 'copy'

  input:
    tuple sample_id, file(bam)

  output:
    file ("wgs_metrics.txt")

  script:
  """
  gatk --java-options -Xmx${task.memory.toGiga()-4}g \
  CollectWgsMetrics \
  -I $bam \
  -O wgs_metrics.txt \
  -R $params.genome_fasta \
  """
}
