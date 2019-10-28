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
include MergeVCFs as MergeGVCFChunks from '../GATK/4.1.3.0/MergeVCFs.nf' params(params)
include MergeVCFs as MergeVCFChunks from '../GATK/4.1.3.0/MergeVCFs.nf' params(params)
include GenotypeGVCFs from '../GATK/4.1.3.0/GenotypeGVCFs.nf' params(params)
include CombineGVCFs from '../GATK/4.1.3.0/CombineGVCFs.nf' params(params)
include CollectMultipleMetrics from '../GATK/4.1.3.0/CollectMultipleMetrics.nf' params(params)
include CollectWGSMetrics from '../GATK/4.1.3.0/CollectWGSMetrics.nf' params(params)
include MultiQC from '../MultiQC/1.5/MultiQC.nf' params(params)

/*  Check if all necessary input parameters are present (yes still very rudimentary)*/
if (!params.fastq_path){
  exit 1, "No 'fastq_path' parameter found in config file!"
}

if (!params.out_dir){
  exit 1, "No 'out_dir' parameter found in config file!"
}


workflow {
  run_id = params.out_dir.split('/')[-1]

  /* Gather input FastQ's */
  input_fastq = extractFastqFromDir(params.fastq_path)

  /* Create intervals to scatter/gather over (used for most of the GATK processes) */
  interval_files = SplitIntervals( Channel.fromPath(params.scatter_interval_list) ).collect()

  /* Run fastqc on a per sample per lane basis */
  FastQC(input_fastq)

  /* Run mapping on a per sample per lane basis */
  BWAMapping(input_fastq)

  /* Mark duplicates & Merge lane bam files*/
  MarkDup(BWAMapping.out.groupTuple())

  /* Run CollectMultipleMetrics per sample */
  CollectMultipleMetrics(MarkDup.out.map{ sample_id, bam, bai -> [sample_id, bam]})

  /* Run WGSMetrics per sample */
  CollectWGSMetrics(MarkDup.out.map{ sample_id, bam, bai -> [sample_id, bam]})

  /* Create base recalibration table per interval per sample*/
  BaseRecalibrationTable(MarkDup.out.spread(interval_files))

  /* Merge the base recalibration tables per samples*/
  GatherBaseRecalibrationTables(BaseRecalibrationTable.out.groupTuple())


  /* Apply the base relalibration per interval per sample */
  bqsr_per_interval_per_sample = MarkDup.out
    .combine(GatherBaseRecalibrationTables.out, by:0)
    .spread(interval_files)

  BaseRecalibration(bqsr_per_interval_per_sample)

  /* Run haplotype calling per sample per interval*/
  HaplotypeCaller(BaseRecalibration.out)

  /* Create GVCF per sample per interval */
  gvcf_per_interval_per_sample = HaplotypeCaller.out.groupTuple(by:[1]).map{
    sample_ids, interval, gvcfs, idxs, interval_files ->
    [run_id, interval, gvcfs, idxs, interval_files[0]]
  }

  /* Merge GVCFs per sample for storage */
  gvcfs_per_sample = HaplotypeCaller.out.groupTuple(by:[0]).map{
    sample_id, intervals, gvcfs, idxs, interval_files ->
    [sample_id, gvcfs, idxs]
  }
  MergeGVCFChunks(gvcfs_per_sample)


  /* Combine GVCFs per interval */
  gvcf_per_interval = CombineGVCFs(gvcf_per_interval_per_sample)


  /* Genotype GVCFs per interval */
  vcf_per_interval = GenotypeGVCFs(gvcf_per_interval).groupTuple().map{
    run_id, interval, vcfs, idxs, interval_files ->
      [run_id, vcfs, idxs]
  }

  /* Merge genotyped vcf files */
  MergeVCFChunks(vcf_per_interval)

  /* Run MultiQC (wait for last process to finish) */
  MultiQC( MergeVCFChunks.out.map{ id, vcf, idx -> id } )
}
