process Index {
  tag {"SAMBAMBA_Index ${sample_id}"}
  label 'SAMBAMBA_0_6_8'
  label 'SAMBAMBA_0_6_8_Index'
  container = 'library://sawibo/default/bioinf-tools:sambamba-0.6.8'
  shell = ['/bin/bash', '-euo', 'pipefail']

  input:
    tuple(sample_id, path(bam))

  output:
    tuple(sample_id, path("${bam}.bai"), emit: bam_index)

  script:
  """
  sambamba index -t ${task.cpus} ${bam} ${bam}.bai
  """
}
