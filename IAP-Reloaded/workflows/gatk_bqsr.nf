include BaseRecalibrationTable from '../../GATK/4.1.3.0/BaseRecalibrationTable.nf' params(params)
include BaseRecalibration from '../../GATK/4.1.3.0/BaseRecalibration.nf' params(params)
include GatherBaseRecalibrationTables from '../../GATK/4.1.3.0/GatherBaseRecalibrationTables.nf' params(params)
include MergeBams from '../../Sambamba/0.6.8/MergeBams.nf' params(params)
include SplitIntervals from '../../GATK/4.1.3.0/SplitIntervals.nf' params(params)

workflow gatk_bqsr {
  get:
    sample_bams

  main:
    /* Create intervals to scatter/gather over */
    SplitIntervals( 'no-break', Channel.fromPath( params.scatter_interval_list) )

    /* Create base recalibration table per interval per sample*/
    BaseRecalibrationTable( sample_bams.combine(SplitIntervals.out.flatten()) )

    /* Merge the base recalibration tables per samples*/
    GatherBaseRecalibrationTables(BaseRecalibrationTable.out.groupTuple())

    /* Apply the base relalibration per interval per sample */
    BaseRecalibration(
      sample_bams
        .combine(GatherBaseRecalibrationTables.out, by:0)
        .combine(SplitIntervals.out.flatten())
    )
    //BaseRecalibration.out.groupTuple().view()
    MergeBams(
      BaseRecalibration.out
        .groupTuple()
        .map{ [it[0],it[2],it[3]] }
    )
  emit:
    MergeBams.out

}
