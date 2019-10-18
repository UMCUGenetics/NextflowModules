process HaplotypeCaller {
    tag {"HaplotypeCaller ${sample_id}.${int_tag}"}
    container = '/hpc/cog_bioinf/cuppen/personal_data/sander/scripts/Nextflow/Singularity-images/gatk4.1.3.0.squashfs'
    //publishDir "$params.out_dir/$sample_id/gvcf/", mode: 'copy'
    cpus 1
    penv 'threaded'
    memory '4 GB'
    time '4h'

    input:
      set sample_id, file(bam), file(bai),file(interval)

    output:
      set sample_id, file("${sample_id}.${int_tag}.g.vcf")

    script:
    int_tag = interval.baseName

    """
    gatk --java-options -Xmx${task.memory.toGiga()}g \
    HaplotypeCaller \
    --input $bam \
    --output ${sample_id}.${int_tag}.g.vcf \
    --tmp-dir /tmp \
    -R $params.genome_fasta \
    -ERC GVCF \
    -L $interval
    """
}
