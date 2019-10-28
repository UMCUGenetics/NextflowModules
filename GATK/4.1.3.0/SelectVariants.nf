process SelectVariants {
    tag {"SelectVariants ${run_id}.${interval}.${type}"}
    label 'GATK'
    container = '/hpc/cog_bioinf/cuppen/personal_data/sander/scripts/Nextflow/Singularity-images/gatk4.1.3.0.squashfs'

    //publishDir "$params.out_dir/vcf/", mode: 'copy'

    memory '4 GB'
    time '4h'

    input:
      tuple run_id, interval, type, file(vcf),file(vcfidx), file(interval_file)

    output:
      tuple run_id, interval, type, file("${run_id}.${interval}.${type}.tmp.vcf"), file("${run_id}.${interval}.${type}.tmp.vcf.idx"), file(interval_file)

    script:
    select_type = type == 'SNP' ? '-selectType SNP -selectType NO_VARIATION' : '-selectType INDEL -selectType MIXED'
    """
    gatk --java-options -Xmx${task.memory.toGiga()-4}g \
    VariantFiltration \
    -R $params.genome_fasta \
    -V $vcf \
    -O ${run_id}.${interval}.${type}.tmp.vcf \
    $select_type
    """
}
