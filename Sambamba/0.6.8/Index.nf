process Index {
  tag {"SAMBAMBA_Index ${sample_id}"}
  label 'SAMBAMBA_0_6_8'
  label 'SAMBAMBA_0_6_8_Index'
  clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.index_mem}" : ""
  container = '/hpc/local/CentOS7/cog_bioinf/nextflow_containers/Sambamba/sambamba_0.6.8-squashfs-pack.gz.squashfs'
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



