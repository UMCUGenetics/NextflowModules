process MergeVCFs {
    tag {"GATK_mergevcfs ${id}"}
    label 'GATK_4_1_3_0'
    label 'GATK_mergevcfs_4_1_3_0'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mergevcf.mem}" : ""
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
      tuple id, file(vcf_chunks), file(vcfidxs)

    output:
      tuple id, file("${id}${ext}.gz"), file("${id}${ext}.gz.tbi")

    script:
    ext = vcf_chunks[0] =~ /\.g\.vcf/ ? '.g.vcf' : '.vcf'
    vcfs = vcf_chunks.join(' -INPUT ')

    """
    gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$PWD" \
    SortVcf \
    --INPUT $vcfs \
    --OUTPUT ${id}${ext}

    bgzip ${id}${ext}
    tabix ${id}${ext}.gz
    """
}
