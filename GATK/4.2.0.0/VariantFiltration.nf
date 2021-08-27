process VariantFiltrationSnpIndel {
    tag {"GATK VariantFiltrationSnpIndel ${analysis_id}"}
    label 'GATK_4_2_0_0'
    label 'GATK_4_2_0_0_VariantFiltrationSnpIndel'
    container = 'broadinstitute/gatk:4.2.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(analysis_id, path(vcf_file), path(vcf_idx_file))

    output:
        tuple(analysis_id, path("${vcf_file.baseName}.filter.vcf"), path("${vcf_file.baseName}.filter.vcf.idx"), emit: vcf_file)

    script:
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}G" SelectVariants --reference ${params.genome} --variant $vcf_file --output ${vcf_file.baseName}.snp.vcf --select-type-to-exclude INDEL
        gatk --java-options "-Xmx${task.memory.toGiga()-4}G" SelectVariants --reference ${params.genome} --variant $vcf_file --output ${vcf_file.baseName}.indel.vcf --select-type-to-include INDEL

        gatk --java-options "-Xmx${task.memory.toGiga()-4}G" VariantFiltration --reference ${params.genome} --variant ${vcf_file.baseName}.snp.vcf --output ${vcf_file.baseName}.snp_filter.vcf ${params.snp_filter} ${params.snp_cluster}
        gatk --java-options "-Xmx${task.memory.toGiga()-4}G" VariantFiltration --reference ${params.genome} --variant ${vcf_file.baseName}.indel.vcf --output ${vcf_file.baseName}.indel_filter.vcf ${params.indel_filter}

        gatk --java-options "-Xmx${task.memory.toGiga()-4}G" MergeVcfs --INPUT ${vcf_file.baseName}.snp_filter.vcf --INPUT ${vcf_file.baseName}.indel_filter.vcf --OUTPUT ${vcf_file.baseName}.filter.vcf
        """
}

process VariantFiltration {
    tag {"GATK VariantFiltration ${identifier}"}
    label 'GATK_4_2_0_0'
    label 'GATK_4_2_0_0_VariantFiltration'
    container = 'broadinstitute/gatk:4.2.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(identifier, path(vcf_file), path(vcf_idx_file))

    output:
        tuple(identifier, path("${output_prefix}${ext_vcf}"), path("${output_prefix}${ext_vcf}${ext_vcf_index}"), emit: vcf_file)

    script:
        def ext_vcf = params.compress || vcf_file.getExtension() == ".gz" ? ".vcf.gz" : ".vcf"
        def ext_vcf_index = params.compress || vcf_file.getExtension() == ".gz" ? ".tbi" : ".idx"
        def output_prefix = params.output_prefix ?  params.output_prefix : identifier + "_filter"
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}G" VariantFiltration \
        --reference ${params.genome} \
        --variant ${vcf_file} \
        --output ${output_prefix}${ext_vcf} \
        ${params.filter} \
        ${params.optional}
        """
}