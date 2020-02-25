process MergeBams {
  tag {"SAMBAMBA_mergebams ${sample_id}"}
  label 'SAMBAMBA_mergebams_0_6_8'

  clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mergebams.mem}" : ""
  container = 'library://sawibo/default/bioinf-tools:sambamba-0.6.8'
  
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
