process MarkDup {
  tag {"SAMBAMBA_markdup ${sample_id}"}
  label 'SAMBAMBA_markdup_0_6_8'
  clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.markdup_mem}" : ""
  container = "/hpc/cog_bioinf/ubec/tools/rnaseq_containers/sambamba_0.6.8-squashfs-pack.gz.squashfs"
  shell = ['/bin/bash', '-euo', 'pipefail']

  input:
    tuple sample_id, file(bam_input), file(bai_input)

  output:
    tuple sample_id, file("${bam_input.baseName}_dedup.bam")

  script:
  """
  sambamba markdup --tmpdir=\$PWD/tmp -t ${task.cpus} ${bam_input} ${bam_input.baseName}_dedup.bam
  """
}



