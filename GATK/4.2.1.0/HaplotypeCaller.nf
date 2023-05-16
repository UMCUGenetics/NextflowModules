process HaplotypeCaller {
    tag {"GATK HaplotypeCaller ${analysis_id} - ${interval_file.baseName}"}
    label 'GATK_4_2_1_0'
    label 'GATK_4_2_1_0_HaplotypeCaller'
    container = 'broadinstitute/gatk:4.2.1.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(analysis_id, path(bam_files), path(bai_files), path(interval_file))

    output:
        tuple(
            val(analysis_id),
            path("${analysis_id}.${interval_file.simpleName}${ext_vcf}"),
            path("${analysis_id}.${interval_file.simpleName}${ext_vcf}${ext_vcf_index}"),
            emit: vcf_file
        )

    script:
        def input_files = bam_files.collect{"$it"}.join(" --input ")
        ext_vcf = params.compress ? ".vcf.gz" : ".vcf"
        ext_vcf_index = params.compress ? ".tbi" : ".idx"
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}G" HaplotypeCaller \
        --reference ${params.genome} \
        --input ${input_files} \
        --intervals ${interval_file} \
        --output ${analysis_id}.${interval_file.simpleName}${ext_vcf} \
        ${params.optional}
        """
}

process HaplotypeCallerGVCF {
    tag {"GATK HaplotypeCallerGVCF ${sample_id} - ${interval_file.baseName}"}
    label 'GATK_4_2_1_0'
    label 'GATK_4_2_1_0_HaplotypeCallerGVCF'
    container = 'broadinstitute/gatk:4.2.1.0'
    shell = ['/bin/bash', '-euo', 'pipefail']
    params.emit_ref_confidence = 'GVCF'

    input:
        tuple(sample_id, path(bam_file), path(bai_file), path(interval_file))

    output:
        tuple(
            val(sample_id),
            path("${sample_id}_${interval_file.simpleName}${ext_gvcf}"),
            path("${sample_id}_${interval_file.simpleName}${ext_gvcf}${ext_gvcf_index}"),
            path(interval_file),
            emit: vcf_file
        )

    script:
        ext_gvcf = params.compress ? ".g.vcf.gz" : ".g.vcf"
        ext_gvcf_index = params.compress ? ".tbi" : ".idx"
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}G" HaplotypeCaller \
        --reference ${params.genome} \
        --input ${bam_file} \
        --intervals ${interval_file} \
        --output ${sample_id}_${interval_file.simpleName}${ext_gvcf} \
        --emit-ref-confidence ${params.emit_ref_confidence} \
        ${params.optional}
        """
}
