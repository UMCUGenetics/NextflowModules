process HaplotypeCaller {
    tag {"GATK_haplotypecaller ${sample_id}.${int_tag}"}
    label 'GATK_4_1_3_0'
    label 'GATK_haplotypecaller_4_1_3_0'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.haplotypecaller.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:gatk4.1.3.0'

    input:
      tuple sample_id, file(bam), file(bai), file(interval_file)

    output:
      tuple sample_id, int_tag ,file("${sample_id}.${int_tag}.g.vcf"), file("${sample_id}.${int_tag}.g.vcf.idx"), file(interval_file)

    script:
    int_tag = interval_file.toRealPath().toString().split("/")[-2]

    """
    gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
    HaplotypeCaller \
    ${params.haplotypecaller.toolOptions} \
    -I $bam \
    --output ${sample_id}.${int_tag}.g.vcf \
    -R $params.genome_fasta \
    -L $interval_file
    """
}
