process SelectVariants {
    tag {"GATK SelectVariants ${run_id}.${interval}.${type}"}
    label 'GATK_4_3_0_0'
    label 'GATK_4_3_0_0_SelectVariants'
    container = 'broadinstitute/gatk:4.3.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(run_id), val(interval), path(vcf), path(vcftbi), val(type))

    output:
        tuple(
            val(run_id),
            val(interval),
            val(type),
            path("${run_id}.${interval}.${type}.tmp.${ext_vcf}"),
            path("${run_id}.${interval}.${type}.tmp.${ext_index}"),
            emit: selected_vcfs
        )

    script:
        select_type = type == 'SNP' ? '--select-type SNP --select-type NO_VARIATION' : '--select-type INDEL --select-type MIXED'
        ext_vcf = params.compress || gvcf_chunks.getExtension() == "gz" ? "vcf.gz" : "vcf"
        ext_index = params.compress || gvcf_chunks.getExtension() == "gz" ? "vcf.gz.tbi" : "vcf.idx"

        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" SelectVariants \
        --tmp-dir \$TMPDIR \
        -R ${params.genome_fasta} \
        -V $vcf \
        -O ${run_id}.${interval}.${type}.tmp.${ext_vcf} \
        $select_type
        """
}
