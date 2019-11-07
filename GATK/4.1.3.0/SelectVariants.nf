process SelectVariants {
    tag {"SelectVariants ${run_id}.${interval}.${type}"}
    label 'GATK'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.selectvariants_mem}" : ""

    input:
      tuple run_id, interval, file(vcf),file(vcfidx),type

    output:
      tuple run_id, interval, type, file("${run_id}.${interval}.${type}.tmp.vcf"), file("${run_id}.${interval}.${type}.tmp.vcf.idx")

    script:
    select_type = type == 'SNP' ? '--select-type SNP --select-type NO_VARIATION' : '--select-type INDEL --select-type MIXED'
    """
    gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
    SelectVariants \
    -R $params.genome_fasta \
    -V $vcf \
    -O ${run_id}.${interval}.${type}.tmp.vcf \
    $select_type
    """
}
