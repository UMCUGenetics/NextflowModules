include BWAMapping from '../../BWA-Mapping/bwa-0.7.17_samtools-1.9/Mapping.nf' params(params)
include MarkDup from '../../Sambamba/0.6.8/MarkDup.nf' params(params)

workflow bwa_mapping {
  get:
    fastqs
  main:
    /* Run mapping on a per sample per lane basis */
    BWAMapping(fastqs)

    /* Mark duplicates & Merge lane bam files*/
    MarkDup(BWAMapping.out.groupTuple())
  emit:
    MarkDup.out
}
