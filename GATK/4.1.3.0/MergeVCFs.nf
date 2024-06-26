process MergeVCFs {
    tag {"GATK MergeVCFs ${id}"}
    label 'GATK_4_1_3_0'
    label 'GATK_4_1_3_0_MergeVCFs'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:gatk4.1.3.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(id), path(vcf_chunks), path(vcfidxs))

    output:
        tuple(val(id), path("${id}${ext}.gz"), path("${id}${ext}.gz.tbi"), emit: merged_vcfs)

    script:
        ext = vcf_chunks[0] =~ /\.g\.vcf/ ? '.g.vcf' : '.vcf'
        vcfs = vcf_chunks.join(' -INPUT ')

        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
        SortVcf \
        --INPUT $vcfs \
        --OUTPUT ${id}${ext} \
        --TMP_DIR \$TMPDIR

        bgzip ${id}${ext}
        tabix ${id}${ext}.gz
        """
}
