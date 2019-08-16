process HaplotypeCaller {
    tag {"HaplotypeCaller ${sample_id}"}
    container = '/hpc/cog_bioinf/cuppen/personal_data/sander/scripts/Nextflow/Singularity-images/gatk4.1.3.0.squashfs'
    publishDir "$params.out_dir/gvcf/", mode: 'copy'
    cpus 10
    penv 'threaded'
    memory '32 GB'
    time '1h'

    input:
      set sample_id, file(bam)

    output:
      set sample_id, file("${sample_id}_dedup_recalibrated.bam")

    script:
    intervals = params.genome_intervals ? "-L ${params.genome_intervals} " : ''

    """
    gatk --java-options -Xmx${task.memory.toGiga()}g \
    HaplotypeCaller \
    --input $bam \
    --output ${sample_id}.g.vcf \
    --tmp-dir /tmp \
    -R $params.genome_fasta \
    -ERC GVCF
    $intervals
    """
}
