process HaplotypeCaller {
    tag {"GATK_Haplotypecaller ${sample_id}.${int_tag}"}
    label 'GATK_4_1_3_0'
    label 'GATK_4_1_3_0_Haplotypecaller'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:gatk4.1.3.0'

    input:
      tuple sample_id, file(bam), file(bai), file(interval_file)

    output:
      tuple sample_id, int_tag ,file("${sample_id}.${int_tag}${ext}"), file("${sample_id}.${int_tag}${ext}.idx"), file(interval_file)

    script:
    int_tag = interval_file.toRealPath().toString().split("/")[-2]
    ext = params.optional =~ /GVCF/ ? '.g.vcf' : '.vcf'   
    """
    gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
    HaplotypeCaller \
    ${params.optional} \
    -I $bam \
    --output ${sample_id}.${int_tag}${ext} \
    -R $params.genome_fasta \
    -L $interval_file 
    """
}
