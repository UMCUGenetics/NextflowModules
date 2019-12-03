include HaplotypeCaller from '../../GATK/4.1.3.0/HaplotypeCaller.nf' params(params)
include CombineGVCFs from '../../GATK/4.1.3.0/CombineGVCFs.nf' params(params)
include MergeVCFs from '../../GATK/4.1.3.0/MergeVCFs.nf' params(params)
include GenotypeGVCFs from '../../GATK/4.1.3.0/GenotypeGVCFs.nf' params(params)
include SplitIntervals from '../../GATK/4.1.3.0/SplitIntervals.nf' params(params)

workflow gatk_germline_calling {
  get:
    sample_bams
  main:
    run_id = params.out_dir.split('/')[-1]

    /* Create intervals to scatter/gather over */
    SplitIntervals( 'break', Channel.fromPath(params.scatter_interval_list) )

    /* Run haplotype calling per sample per interval*/
    HaplotypeCaller( sample_bams.combine(SplitIntervals.out.flatten()))

    /* Combine GVCFs per interval */
    CombineGVCFs(
      HaplotypeCaller.out.groupTuple(by:[1]).map{
        sample_ids, interval, gvcfs, idxs, interval_files ->
        [run_id, interval, gvcfs, idxs, interval_files[0]]
      }
    )

    /* Merge GVCFs per sample for storage */
    MergeVCFs(
      HaplotypeCaller.out.groupTuple(by:[0]).map{
        sample_id, intervals, gvcfs, idxs, interval_files ->
        [sample_id, gvcfs, idxs]
      }
    )

    /* Genotype GVCFs per interval */
    GenotypeGVCFs(CombineGVCFs.out)
  emit:
    GenotypeGVCFs.out
}
