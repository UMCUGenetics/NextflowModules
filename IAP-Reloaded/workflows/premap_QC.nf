include FastQC from '../../FastQC/0.11.8/FastQC.nf' params(params)

workflow premap_QC {
  get:
    fastqs
  main:
    /* Run fastqc on a per sample per lane basis */
    FastQC(fastqs)
  emit:
    FastQC.out
}
