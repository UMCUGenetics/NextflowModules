
process CollectMultipleMetrics {
  tag {"GATK_collectmultiplemetrics ${sample_id}"}
  label 'GATK_4_1_3_0'
  label 'GATK_collectmultiplemetrics_4_1_3_0'
  clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.collectmultiplemetrics.mem}" : ""

  input:
    tuple sample_id, file(bam)

  output:
    file ("multiple_metrics*")

  script:
  """
  gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
  CollectMultipleMetrics \
  -I $bam \
  -O multiple_metrics\
  -R $params.genome_fasta \
  ${params.collectmultiplemetrics.toolOptions}
  """
}
