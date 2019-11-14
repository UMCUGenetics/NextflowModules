
process snpEffFilter {
    tag {"SNPEFF_snpefffilter ${run_id}"}
    label 'SNPEFF_4_3t'
    label 'SNPEFF_snpefffilter_4_3t'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.snpefffilter.mem}" : ""
    input:
      tuple run_id, file(vcf), file(vcfidx)

    output:
      tuple run_id, file("${vcf.baseName}.filtered_variants.vcf"), file("${vcf.baseName}.filtered_variants.vcf.idx")

    script:

    """
    set -o pipefail

    java -Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR -jar /bin/snpEff.jar \
    -c snpEff.config ${params.snpefffilter.toolOptions} \
    -v $vcf \
    > ${vcf.baseName}.filtered_variants.vcf

    java -Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR -jar /bin/igvtools.jar index ${vcf.baseName}.filtered_variants.vcf

    """
}
