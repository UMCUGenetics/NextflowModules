
process MarkDup {
  tag {"MarkDup ${sample_id}"}
  publishDir "$params.out_dir/$sample_id/mapping", mode: 'copy'

  clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.markdup_mem}" : ""

  input:
    tuple sample_id, rg_ids, file(bams), file(bais)

  output:
    tuple sample_id, file("${sample_id}_dedup.bam"), file("${sample_id}_dedup.bai")

  script:
  """
  sambamba markdup --tmpdir=\$PWD/tmp --overflow-list-size=${params.sambamba_listsize} -t ${task.cpus} ${bams} ${sample_id}_dedup.bam
  sambamba index -t ${task.cpus} ${sample_id}_dedup.bam ${sample_id}_dedup.bai
  """
}
