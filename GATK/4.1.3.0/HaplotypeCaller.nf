process HaplotypeCaller {
    tag {"HaplotypeCaller ${sample_id}.${int_tag}"}
    label 'GATK'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.haplotypecaller_mem}" : ""

    input:
      tuple sample_id, file(bam), file(bai), file(interval_file)

    output:
      tuple sample_id, int_tag ,file("${sample_id}.${int_tag}.g.vcf"), file("${sample_id}.${int_tag}.g.vcf.idx"), file(interval_file)

    script:
    int_tag = interval_file.toRealPath().toString().split("/")[-2]

    """
    gatk --java-options -Xmx${task.memory.toGiga()-4}g \
    HaplotypeCaller \
    -I $bam \
    --output ${sample_id}.${int_tag}.g.vcf \
    --tmp-dir /tmp \
    -R $params.genome_fasta \
    -ERC GVCF \
    -L $interval_file
    """
}
