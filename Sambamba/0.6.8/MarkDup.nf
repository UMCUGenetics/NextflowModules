process MarkDup {
  tag {"Sambamba MarkDup ${sample_id}"}
  label 'Sambamba_0_6_8'
  label 'Sambamba_0_6_8_MarkDup'
  clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
  container = 'library://sawibo/default/bioinf-tools:sambamba-0.6.8'
  shell = ['/bin/bash', '-euo', 'pipefail']
  input:
    tuple (sample_id, rg_ids, path(bams), path(bais))

  output:
    tuple (sample_id, path("${sample_id}_dedup.bam"), path("${sample_id}_dedup.bai"), emit: deduplicated_bams)

  script:
    """
    sambamba markdup ${params.optional} --tmpdir=\$PWD/tmp -t ${task.cpus} ${bams} ${sample_id}_dedup.bam
    sambamba index -t ${task.cpus} ${sample_id}_dedup.bam ${sample_id}_dedup.bai
    """
}
