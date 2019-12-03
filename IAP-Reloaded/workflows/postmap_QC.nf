include CollectMultipleMetrics from '../../GATK/4.1.3.0/CollectMultipleMetrics.nf' params(params)
include CollectWGSMetrics from '../../GATK/4.1.3.0/CollectWGSMetrics.nf' params(params)
include MultiQC from '../../MultiQC/1.5/MultiQC.nf' params(params)

workflow postmap_QC {
  get:
    bams
  main:
    run_id = params.out_dir.split('/')[-1]
    /* Run CollectMultipleMetrics per sample */
    CollectMultipleMetrics(
      bams.map{
        sample_id, bam, bai -> [sample_id, bam]
      }
    )
    /* Run WGSMetrics per sample */
    CollectWGSMetrics(
      bams.map{
        sample_id, bam, bai -> [sample_id, bam]
      }
    )

    /* Run MultiQC (wait for last process to finish) */
    //MultiQC( MergeVCFChunks.out.map{ id, vcf, idx -> id } )
    MultiQC(
      CollectMultipleMetrics.out
        .combine(CollectWGSMetrics.out)
        .map {
          it -> run_id
        }
    )
  


}
