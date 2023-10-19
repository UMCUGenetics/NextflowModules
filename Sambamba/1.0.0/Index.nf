process Index {
  tag {"Sambamba Index ${sample_id}"}
  label 'Sambamba_1_0_0'
  label 'Sambamba_1_0_0_Index'
  container = 'quay.io/biocontainers/sambamba:1.0--h98b6b92_0'
  shell = ['/bin/bash', '-euo', 'pipefail']

  input:
      tuple(val(sample_id), path(bam_file))

  output:
      tuple(val(sample_id), path("${bam_file}.bai"), emit: bai_file)

  script:
      """
      sambamba index -t ${task.cpus} ${bam_file} ${bam_file}.bai
      """
}
