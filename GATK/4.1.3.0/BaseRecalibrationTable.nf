
process BaseRecalibrationTable {
    tag {"BaseRecalibrationTable ${sample_id}.${int_tag}"}
    container = '/hpc/cog_bioinf/cuppen/personal_data/sander/scripts/Nextflow/Singularity-images/gatk4.1.3.0.squashfs'
    //publishDir "$params.out_dir/$sample_id/mapping", mode: 'copy'
    cpus 1
    penv 'threaded'
    memory '4 GB'
    time '1h'

    input:
      set sample_id, file(bam), file(bai),file(interval)

    output:
      set sample_id, file("${sample_id}.${int_tag}.recal.table")

    script:
    known = params.genome_known_sites ? '--known-sites ' + params.genome_known_sites.join(' --known-sites ') : ''
    int_tag = interval.baseName
    """
    gatk --java-options -Xmx${task.memory.toGiga()}g \
    BaseRecalibrator \
    --input $bam \
    --output ${sample_id}.${int_tag}.recal.table \
    --tmp-dir /tmp \
    -R $params.genome_fasta \
    $known \
    -L $interval
    """
}
