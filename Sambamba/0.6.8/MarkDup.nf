process MarkDup {
  tag {"SAMBAMBA_markdup ${sample_id}"}
  label 'SAMBAMBA_markdup_0_6_8'
  clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.markdup_mem}" : ""
  container = "/hpc/cog_bioinf/ubec/tools/rnaseq_containers/sambamba_0.6.8-squashfs-pack.gz.squashfs"
  shell = ['/bin/bash', '-euo', 'pipefail']

  input:
    tuple sample_id, file(bams), file(bais)

  output:
    tuple sample_id, file("${bams.baseName}_dedup.bam")

  script:
  """
  sambamba markdup ${params.sambamba.markdup.optional} --tmpdir=\$PWD/tmp -t ${task.cpus} ${bams} ${bams.baseName}_dedup.bam
  """
}



