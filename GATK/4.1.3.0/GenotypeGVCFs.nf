process GenotypeGVCFs {
    tag {"GATK_Genotypegvcfs ${run_id}.${interval}"}
    label 'GATK_4_1_3_0'
    label 'GATK_4_1_3_0_Genotypegvcfs'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:gatk4.1.3.0'

    input:
      tuple run_id, interval, file(gvcf), file(gvcfidx), file(interval_file)


    output:
      tuple run_id, interval, file("${run_id}.${interval}.vcf"),file("${run_id}.${interval}.vcf.idx"),file(interval_file)

    script:

    """
    gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
    GenotypeGVCFs \
    -V $gvcf \
    -O ${run_id}.${interval}.vcf \
    -R ${params.genome_fasta} \
    -D ${params.genome_dbsnp} \
    -L $interval_file
    """
}
