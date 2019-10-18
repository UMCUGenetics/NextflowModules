#!/usr/bin/env nextflow

nextflow.preview.dsl=2

include '../Utils/utils.nf'
include FastQC from '../FastQC/0.11.8/FastQC.nf' params(params)
include BWAMapping from '../BWA-Mapping/bwa-0.7.17_samtools-1.9/Mapping.nf' params(params)
include MarkDup from '../Sambamba/0.6.8/MarkDup.nf' params(params)
include BaseRecalibrationTable from '../GATK/4.1.3.0/BaseRecalibrationTable.nf' params(params)
include BaseRecalibration from '../GATK/4.1.3.0/BaseRecalibration.nf' params(params)
include HaplotypeCaller from '../GATK/4.1.3.0/HaplotypeCaller.nf' params(params)
include SplitIntervals from '../GATK/4.1.3.0/SplitIntervals.nf' params(params)
include GatherBaseRecalibrationTables from '../GATK/4.1.3.0/GatherBaseRecalibrationTables.nf' params(params)
include MergeGVCFs from '../GATK/4.1.3.0/MergeGVCFs.nf' params(params)


// Check if all necessary input parameters are present
if (!params.fastq_path){
  exit 1, "No 'fastq_path' parameter found in config file!"
}

if (!params.out_dir){
  exit 1, "No 'out_dir' parameter found in config file!"
}



input_fastq = extractFastqFromDir(params.fastq_path)

interval_files = SplitIntervals( Channel.fromPath(params.scatter_interval_list) ).collect()

FastQC(input_fastq)
BWAMapping(input_fastq)
MarkDup(BWAMapping.out.groupTuple())
BaseRecalibrationTable(MarkDup.out.spread(interval_files))
GatherBaseRecalibrationTables(BaseRecalibrationTable.out.groupTuple())
BaseRecalibration(MarkDup.out.combine(GatherBaseRecalibrationTables.out, by:0).view())
HaplotypeCaller(BaseRecalibration.out.spread(interval_files))
MergeGVCFs(HaplotypeCaller.out.groupTuple())
