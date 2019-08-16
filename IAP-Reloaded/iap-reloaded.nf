#!/usr/bin/env nextflow

nextflow.preview.dsl=2

include '../Utils/utils.nf'
include FastQC from '../FastQC/0.11.8/FastQC.nf' params(params)
include BWAMapping from '../BWA-Mapping/bwa-0.7.17_samtools-1.9/Mapping.nf' params(params)
include MarkDup from '../Sambamba/0.6.8/MarkDup.nf' params(params)
include BaseRecalibrationTable from '../GATK/4.1.3.0/BaseRecalibrationTable.nf' params(params)
include BaseRecalibration from '../GATK/4.1.3.0/BaseRecalibration.nf' params(params)
include HaplotypeCaller from '../GATK/4.1.3.0/HaplotypeCaller.nf' params(params)

// Check if all necessary input parameters are present
if (!params.fastq_path){
  exit 1, "No 'fastq_path' parameter found in config file!"
}

if (!params.out_dir){
  exit 1, "No 'out_dir' parameter found in config file!"
}


input_fastq = extractFastqFromDir(params.fastq_path)

FastQC(input_fastq)
BWAMapping(input_fastq)
MarkDup(BWAMapping.out.groupTuple())
BaseRecalibrationTable(MarkDup.out)
BaseRecalibration(MarkDup.out, BaseRecalibrationTable.out)
HaplotypeCaller(BaseRecalibration.out)
