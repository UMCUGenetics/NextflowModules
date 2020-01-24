process index {
  tag {"SAMBAMBA_index ${sample_id}"}
  label 'SAMBAMBA_0_6_8'
  label 'SAMBAMBA_0_6_8_index'
  clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.index_mem}" : ""
  shell = ['/bin/bash', '-euo', 'pipefail']

  input:
    tuple sample_id, file(bam)

  output:
    tuple sample_id, file("${bam}.bai")

  script:
  """
  sambamba index -t ${task.cpus} $bam ${bam}.bai
  """
}



