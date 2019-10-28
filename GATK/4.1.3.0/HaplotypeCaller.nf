process HaplotypeCaller {
    tag {"HaplotypeCaller ${sample_id}.${interval}"}
    label 'GATK'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.haplotypecaller_mem}" : ""

    input:
      tuple sample_id, interval, file(bam), file(bai), file(interval_file)

    output:
      tuple sample_id, interval ,file("${sample_id}.${interval}.g.vcf"), file("${sample_id}.${interval}.g.vcf.idx"), file(interval_file)

    script:

    """
    gatk --java-options -Xmx${task.memory.toGiga()-4}g \
    HaplotypeCaller \
    --input $bam \
    --output ${sample_id}.${interval}.g.vcf \
    --tmp-dir /tmp \
    -R $params.genome_fasta \
    -ERC GVCF \
    -L $interval_file
    """
}
