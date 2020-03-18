process MergeBams {
  tag {"SAMBAMBA_mergebams ${sample_id}"}
  label 'SAMBAMBA_mergebams_0_6_8'

  clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mergebams.mem}" : ""
  container = 'library://sawibo/default/bioinf-tools:sambamba-0.6.8'

  input:
    tuple sample_id, file(bams), file(bais)

  output:
    tuple sample_id, file("${sample_id}_${ext}"), file("${sample_id}_${ext}.bai")

  script:
  ext = bams[0].toRealPath().toString().split("_")[-1]

  """
  sambamba merge -t ${task.cpus} ${sample_id}_${ext} ${bams}
  sambamba index -t ${task.cpus} ${sample_id}_${ext} ${sample_id}_${ext}.bai
  """
}
