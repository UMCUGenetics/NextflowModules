process Index {
  tag {"SAMBAMBA_index ${sample_id}"}
  label 'SAMBAMBA_0_6_8'
  label 'SAMBAMBA_0_6_8_index'
  clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.index_mem}" : ""
  container = 'quay.io/biocontainers/sambamba:0.6.8--h682856c_0'
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



