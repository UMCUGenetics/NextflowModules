

process BaseRecalibration {
    tag {"BaseRecalibration ${sample_id}"}
    container = '/hpc/cog_bioinf/cuppen/personal_data/sander/scripts/Nextflow/Singularity-images/gatk4.1.3.0.squashfs'
    publishDir "$params.out_dir/$sample_id/mapping", mode: 'copy'
    cpus 10
    penv 'threaded'
    memory '32 GB'
    time '1h'

    input:
      set sample_id, file(bam), file(bai)
      file(recal_table)

    output:
      set sample_id, file("${sample_id}_dedup_recalibrated.bam")

    script:
    intervals = params.genome_intervals ? "-L ${params.genome_intervals} " : ''

    """
    gatk --java-options -Xmx${task.memory.toGiga()}g \
    ApplyBQSR \
    --input $bam \
    --output ${sample_id}_dedup_recalibrated.bam \
    --tmp-dir /tmp \
    -R $params.genome_fasta \
    --create-output-bam-index true \
    --bqsr-recal-file ${recal_table} \
    $intervals
    """
}
