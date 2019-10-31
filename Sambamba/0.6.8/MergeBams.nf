process MergeBams {
  tag {"MergeBams ${sample_id}"}
  //publishDir "$params.out_dir/$sample_id/mapping", mode: 'copy'

  clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mergebams_mem}" : ""

  input:
    tuple sample_id, file(bams), file(bais)

  output:
    tuple sample_id, file("${sample_id}_merge.bam"), file("${sample_id}_merge.bai")

  script:
  """
  sambamba merge -t ${task.cpus} ${sample_id}_merge.bam ${bams} 
  sambamba index -t ${task.cpus} ${sample_id}_merge.bam ${sample_id}_merge.bai
  """
}
