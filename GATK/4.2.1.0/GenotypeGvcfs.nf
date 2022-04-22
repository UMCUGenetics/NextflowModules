process GenotypeGVCFs {
    tag {"GATK GenotypeGVCFs ${analysis_id} - ${interval_file.baseName}"}
    label 'GATK_4_2_1_0'
    label 'GATK_4_2_1_0_GenotypeGVCFs'
    container = 'broadinstitute/gatk:4.2.1.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(analysis_id, path(gvcf_files), path(gvcf_idx_files), path(interval_file))

    output:
        tuple(
            analysis_id,
            path("${analysis_id}_${interval_file.baseName}${ext_vcf}"),
            path("${analysis_id}_${interval_file.baseName}${ext_vcf}${ext_vcf_index}"),
            emit:vcf_file
        )

    script:
        def input_files = gvcf_files.collect{"$it"}.join(" --variant ")
        ext_vcf = params.compress || gvcf_files.getExtension() == ".gz" ? ".vcf.gz" : ".vcf"
        ext_vcf_index = params.compress || gvcf_files.getExtension() == ".gz" ? ".tbi" : ".idx"
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}G" GenotypeGVCFs \
        --reference ${params.genome} \
        --variant $input_files \
        --output ${analysis_id}_${interval_file.baseName}${ext_vcf} \
        --intervals ${interval_file} \
        ${params.optional}
        """
}

process GenotypeGVCF {
    tag {"GATK GenotypeGVCF ${sample_id} - ${interval_file.baseName}"}
    label 'GATK_4_2_1_0'
    label 'GATK_4_2_1_0_GenotypeGVCF'
    container = 'broadinstitute/gatk:4.2.1.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(gvcf_files), path(gvcf_idx_files), path(interval_file))

    output:
        tuple(
            val(sample_id),
            path("${sample_id}_${interval_file.baseName}${ext_vcf}"),
            path("${sample_id}_${interval_file.baseName}${ext_vcf}${ext_vcf_index}"),
            emit: vcf_file
        )

    script:
        def input_files = gvcf_files.collect{"$it"}.join(" --variant ")
        ext_vcf = params.compress || gvcf_files.getExtension() == ".gz" ? ".vcf.gz" : ".vcf"
        ext_vcf_index = params.compress || gvcf_files.getExtension() == ".gz" ? ".tbi" : ".idx"
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}G" GenotypeGVCFs \
        --reference ${params.genome} \
        --variant $input_files \
        --output ${sample_id}_${interval_file.baseName}${ext_vcf} \
        --intervals ${interval_file} \
        ${params.optional}
        """
}
