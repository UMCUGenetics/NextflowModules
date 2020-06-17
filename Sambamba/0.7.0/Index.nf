process Index {
  tag {"Sambamba Index ${sample_id}"}
  label 'Sambamba_0_7_0'
  label 'Sambamba_0_7_0_Index'
  container = 'quay.io/biocontainers/sambamba:0.7.0--h89e63da_1'
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
