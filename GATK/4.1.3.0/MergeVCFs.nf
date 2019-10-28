process MergeVCFs {
    tag {"MergeVCFs ${id}"}
    label 'GATK'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mergevcf_mem}" : ""
    memory params.mergevcf_mem
    
    publishDir "$params.out_dir/vcf/", mode: 'copy'

    input:
      tuple id, file(vcf_chunks), file(vcfidxs)

    output:
      tuple id, file("${id}${ext}"), file("${id}${ext}.idx")

    script:
    ext = vcf_chunks[0] =~ /\.g\.vcf/ ? '.g.vcf' : '.vcf'
    vcfs = vcf_chunks.join(' -INPUT ')

    """
    gatk --java-options -Xmx${task.memory.toGiga()-4}g \
    SortVcf \
    --INPUT $vcfs \
    --OUTPUT ${id}${ext}
    """
}
