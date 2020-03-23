process SelectVariants {
    tag {"GATK_Selectvariants ${run_id}.${interval}.${type}"}
    label 'GATK_4_1_3_0'
    label 'GATK_4_1_3_0_Selectvariants'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:gatk4.1.3.0'

    input:
      tuple run_id, interval, file(vcf),file(vcfidx),type

    output:
      tuple run_id, interval, type, file("${run_id}.${interval}.${type}.tmp.vcf"), file("${run_id}.${interval}.${type}.tmp.vcf.idx")

    script:
    select_type = type == 'SNP' ? '--select-type SNP --select-type NO_VARIATION' : '--select-type INDEL --select-type MIXED'
    """
    gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
    SelectVariants \
    -R ${params.genome_fasta} \
    -V $vcf \
    -O ${run_id}.${interval}.${type}.tmp.vcf \
    $select_type
    """
}
