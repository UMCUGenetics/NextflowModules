
process BaseRecalibrationTable {
    tag {"BaseRecalibrationTable ${sample_id}"}
    container = '/hpc/cog_bioinf/cuppen/personal_data/sander/scripts/Nextflow/Singularity-images/gatk4.1.3.0.squashfs'
    publishDir "$params.out_dir/$sample_id/mapping", mode: 'copy'
    cpus 10
    penv 'threaded'
    memory '32 GB'
    time '1h'

    input:
      set sample_id, file(bam), file(bai)


    output:
      file("${sample_id}.recal.table")

    script:
    intervals = params.genome_intervals ? "-L ${params.genome_intervals} " : ''
    known = params.genome_known_sites ? '--known-sites ' + params.genome_known_sites.join(' --known-sites ') : ''
    """
    gatk --java-options -Xmx${task.memory.toGiga()}g \
    BaseRecalibrator \
    --input $bam \
    --output ${sample_id}.recal.table \
    --tmp-dir /tmp \
    -R $params.genome_fasta \
    $known \
    $intervals
    """
}
