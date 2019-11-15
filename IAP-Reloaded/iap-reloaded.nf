#!/usr/bin/env nextflow

nextflow.preview.dsl=2

include '../Utils/utils.nf'
include premap_QC from './workflows/premap_QC.nf' params(params)
include postmap_QC from './workflows/postmap_QC.nf' params(params)
include bwa_mapping from './workflows/bwa_mapping.nf' params(params)
include gatk_bqsr from './workflows/gatk_bqsr.nf' params(params)
include gatk_germline_calling from './workflows/gatk_germline_calling.nf' params(params)
include gatk_variantfiltration from './workflows/gatk_variantfiltration.nf' params(params)
include snpeff_gatk_annotate from './workflows/snpeff_gatk_annotate.nf' params(params)

/*  Check if all necessary input parameters are present (yes still very rudimentary)*/
if (!params.fastq_path && !params.bam_path && !params.vcf_path){
  exit 1, "Please provide either a fastq_path, bam_path or vcf_path!"
}

if (!params.out_dir){
  exit 1, "No 'out_dir' parameter found in config file!"
}


workflow {
  main :
    /* Gather input FastQ's */
    input_fastq = extractFastqFromDir(params.fastq_path)

    if (params.premapQC && params.fastq_path ) { premap_QC(input_fastq) }

    if (params.fastq_path){
      bwa_mapping(input_fastq)
    }
    postmap_QC(bwa_mapping.out)

    gatk_bqsr( bwa_mapping.out )

    gatk_germline_calling(gatk_bqsr.out)

    gatk_variantfiltration(gatk_germline_calling.out)

    snpeff_gatk_annotate(gatk_variantfiltration.out)
}
