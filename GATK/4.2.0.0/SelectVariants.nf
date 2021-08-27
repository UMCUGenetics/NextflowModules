process SelectVariantsSample {
    tag {"GATK SelectVariantsSample ${analysis_id} - ${sample_id}"}
    label 'GATK_4_2_0_0'
    label 'GATK_4_2_0_0_SelectVariantsSample'
    container = 'broadinstitute/gatk:4.2.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(analysis_id, path(vcf_file), path(vcf_idx_file), sample_id)

    output:
        // simpleName instead of baseName, in case of .vcf.gz
        tuple(sample_id, path("${sample_id}_${vcf_file.simpleName}.vcf.gz"), path("${sample_id}_${vcf_file.simpleName}.vcf.gz.tbi"), emit: vcf_file)

    script:
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}G" SelectVariants \
        --reference ${params.genome} \
        -variant ${vcf_file} \
        --output ${sample_id}_${vcf_file.simpleName}.vcf.gz \
        --sample-name ${sample_id} \
        ${params.optional}
        """
}

process SelectVariants {
    tag {"GATK SelectVariants ${identifier}"}
    label 'GATK_4_2_0_0'
    label 'GATK_4_2_0_0_SelectVariants'
    container = 'broadinstitute/gatk:4.2.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(identifier, path(vcf_file), path(vcf_idx_file))

    output:
        tuple(identifier, path("${output_prefix}${ext_vcf}"), path("${output_prefix}${ext_vcf}${ext_vcf_index}"), emit: vcf_file)

    script:
        def ext_vcf = params.compress || vcf_file.getExtension() == ".gz" ? ".vcf.gz" : ".vcf"
        def ext_vcf_index = params.compress || vcf_file.getExtenstion() == ".gz" ? ".tbi" : ".idx"
        def output_prefix = params.output_prefix ?  params.output_prefix : identifier + "_select"
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}G" SelectVariants \
        --reference ${params.genome} \
        -variant ${vcf_file} \
        --output ${output_prefix}${ext_vcf}\
        ${params.optional}
        """
}