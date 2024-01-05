#!/usr/bin/env nextflow
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    UMCUGenetics/DxNextflowRNA
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Github : https://github.com/UMCUGenetics/DxNextflowRNA
----------------------------------------------------------------------------------------
*/

nextflow.enable.dsl = 2

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Validate parameters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

include { validateParameters; } from 'plugin/nf-validation'
validateParameters()

/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Import modules/subworkflows
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/
/*include { BAM_DEDUP_STATS_SAMTOOLS_UMITOOLS } from './subworkflows/nf-core/bam_dedup_stats_samtools_umitools/main'

include { TRIMGALORE } from './modules/nf-core/trimgalore/main'
include { FASTQC } from './modules/nf-core/fastqc/main'
include { MULTIQC } from './modules/nf-core/multiqc/main'
include { SAMTOOLS_INDEX } from './modules/nf-core/samtools/index/main'
include { SAMTOOLS_MERGE } from './modules/nf-core/samtools/merge/main'
include { STAR_ALIGN } from './modules/nf-core/star/align/main'
include { SUBREAD_FEATURECOUNTS } from './modules/nf-core/subread/featurecounts/main'

*/
include { OUTRIDER } from './Outrider/1.20.0/main'
/*
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    Main workflow
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

workflow {
    // Reference file channels
/*    ch_star_index = Channel.fromPath(params.star_index).map {star_index -> [star_index.getSimpleName(), star_index] }
    ch_gtf = Channel.fromPath(params.gtf).map { gtf -> [gtf.getSimpleName(), gtf] }

    // Input channel
    ch_fastq = Channel.fromFilePairs("$params.input/*_R{1,2}_001.fastq.gz")
        .map {
            meta, fastq ->
            def fmeta = [:]
            // Set meta.id
            fmeta.id = meta
            // Set meta.single_end
            if (fastq.size() == 1) {
                fmeta.single_end = true
            } else {
                fmeta.single_end = false
            }
            [ fmeta, fastq ]
        }

    // Trim, Alignment, FeatureCounts
    TRIMGALORE(
        ch_fastq
    )
    
    STAR_ALIGN(
        TRIMGALORE.out.reads,
        ch_star_index.first(),
        ch_gtf.first(),
        false,
        'illumina',
        'UMCU Genetics'
    )

    SAMTOOLS_MERGE(
        STAR_ALIGN.out.bam_sorted.map {
            meta, bam ->
                new_id = meta.id.split('_')[0]
                [ meta + [id: new_id], bam ]
        }.groupTuple(),
        [ [ id:'null' ], []],
        [ [ id:'null' ], []],
    )

    SAMTOOLS_INDEX ( SAMTOOLS_MERGE.out.bam )

    SAMTOOLS_MERGE.out.bam
        .join(SAMTOOLS_INDEX.out.bai)
        .set { ch_bam_bai }

    BAM_DEDUP_STATS_SAMTOOLS_UMITOOLS(
        ch_bam_bai,
        true
    )

    SUBREAD_FEATURECOUNTS(
        BAM_DEDUP_STATS_SAMTOOLS_UMITOOLS.out.bam.map{
        meta, bam -> [ meta, bam, params.gtf ]
        }
    )

    // QC
    FASTQC(ch_fastq)

    // MultiQC
    ch_multiqc_files = Channel.empty()
    ch_multiqc_files = ch_multiqc_files.mix(FASTQC.out.zip.collect{it[1]}.ifEmpty([]))
    ch_multiqc_config = Channel.fromPath("$projectDir/assets/multiqc_config.yml", checkIfExists: true)
    MULTIQC(
        ch_multiqc_files.collect(),
        ch_multiqc_config.toList(),
        Channel.empty().toList(),
        Channel.empty().toList()
    )
*/
    // Input channel
    ch_outrider_in = Channel.fromPath("$params.input/feature_counts/*CHX*.txt")
    ch_outrider_ref = Channel.fromPath("$params.input/feature_counts/*Cntrl*.txt")

    //Outrider
    OUTRIDER(
        ch_outrider_in,
        ch_outrider_ref
    )
}