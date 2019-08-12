
process MarkDup {
  tag {"MergeBams ${sample_id}"}
  publishDir "$params.out_dir/$sample_id/mapping", mode: 'copy'
  container = '/hpc/cog_bioinf/cuppen/personal_data/sander/scripts/Nextflow/Singularity-images/sambamba-0.6.8.squashfs'
  cpus 10
  penv 'threaded'
  memory '32 GB'
  time '18h'

  input:
    set sample_id, rg_ids, file(bams), file(bais)

  output:
    set sample_id, file("${sample_id}_dedup.bam"), file("${sample_id}_dedup.bai")

  script:
  """
  sambamba markdup --tmpdir=\$PWD/tmp --overflow-list-size=${params.sambamba_listsize} -t ${task.cpus} ${bams} ${sample_id}_dedup.bam
  sambamba index -t ${task.cpus} ${sample_id}_dedup.bam ${sample_id}_dedup.bai
  """
}
