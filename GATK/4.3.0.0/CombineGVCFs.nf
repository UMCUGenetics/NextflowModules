process CombineGVCFs {
    tag {"GATK CombineGVCFs ${sample_id}"}
    label 'GATK_4_3_0_0'
    label 'GATK_4_3_0_0_CombineGVCFs'
    container = 'broadinstitute/gatk:4.3.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(gvcf_files), path(gvcf_idx_files))

    output:
        tuple(
            val(sample_id),
            path("${sample_id}.g.vcf"),
            path("${sample_id}.g.vcf.idx"),
            emit: vcf_file
        )

    script:
        def input_files = gvcf_files.collect{"$it"}.join(" --variant ")
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
        CombineGVCFs \
        --reference ${params.genome_fasta} \
        --variant ${input_files} \
        --output ${sample_id}.g.vcf \
        $params.optional
        """
}

process CombineGVCFsInterval {
    tag {"GATK CombineGVCFs ${analysis_id}"}
    label 'GATK_4_3_0_0'
    label 'GATK_4_3_0_0_CombineGVCFs'
    label 'GATK_4_3_0_0_CombineGVCFsInterval'
    container = 'broadinstitute/gatk:4.3.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(analysis_id), path(gvcf_files), path(gvcf_idx_files), path(interval_file))

    output:
        tuple(
            val(analysis_id),
            path("${analysis_id}.${interval_file.baseName}.g.vcf"),
            path("${analysis_id}.${interval_file.baseName}.g.vcf.idx"),
            path(interval_file),
            emit: vcf_file
        )

    script:
        def input_files = gvcf_files.collect{"$it"}.join(" --variant ")
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
        CombineGVCFs \
        --reference ${params.genome_fasta} \
        --variant ${input_files} \
        --output ${analysis_id}.${interval_file.baseName}.g.vcf \
        --intervals ${interval_file} \
        $params.optional
        """
}
