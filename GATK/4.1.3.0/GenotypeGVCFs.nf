process GenotypeGVCFs {
    tag {"GenotypeGVCFs ${run_id}.${interval}"}
    label 'GATK'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.genotypegvcfs_mem}" : ""

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
    -R $params.genome_fasta \
    -D $params.genome_dbsnp \
    -L $interval_file
    """
}
//-stand_call_conf 15 \
//--tmp-dir /tmp \
