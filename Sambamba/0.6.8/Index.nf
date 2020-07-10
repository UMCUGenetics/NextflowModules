process Index {
  tag {"Sambamba Index ${sample_id}"}
  label 'Sambamba_0_6_8'
  label 'Sambamba_0_6_8_Index'
  container = 'library://sawibo/default/bioinf-tools:sambamba-0.6.8'
  shell = ['/bin/bash', '-euo', 'pipefail']

  input:
      tuple(sample_id, path(bam_file))

  output:
      tuple(sample_id, path("${bam_file}.bai"), emit: bai_file)

  script:
      """
      sambamba index -t ${task.cpus} ${bam_file} ${bam_file}.bai
      """
}
