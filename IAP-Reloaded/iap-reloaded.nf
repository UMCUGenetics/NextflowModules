#!/usr/bin/env nextflow

nextflow.preview.dsl=2

// Check if all necessary input parameters are present
if (!params.fastq_path){
  exit 1, "No 'fastq_path' parameter found in config file!"
}

if (!params.out_dir){
  exit 1, "No 'out_dir' parameter found in config file!"
}

include '../Utils/utils.nf'
include FastQC from '../FastQC/0.11.8/FastQC.nf' params(params)


input_fastq = extractFastqFromDir(params.fastq_path).take(1)


FastQC(input_fastq)
