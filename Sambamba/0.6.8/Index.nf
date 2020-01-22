process Index {
  tag {"SAMBAMBA_index ${sample_id}"}
  label 'SAMBAMBA_index_0_6_8'
  clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.index_mem}" : ""
  shell = ['/bin/bash', '-euo', 'pipefail']

  input:
    tuple sample_id, file(bams)

  output:
    tuple sample_id, file("${bams}.bai")

  script:
  """
  sambamba index -t ${task.cpus} $bams ${bams}.bai
  """
}



