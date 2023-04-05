process VariantFiltrationSnpIndel {
    tag {"GATK VariantFiltrationSnpIndel ${analysis_id}"}
    label 'GATK_4_2_1_0'
    label 'GATK_4_2_1_0_VariantFiltrationSnpIndel'
    container = 'broadinstitute/gatk:4.2.1.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(analysis_id, path(vcf_file), path(vcf_idx_file))

    output:
        tuple(analysis_id, path("${vcf_file.simpleName}.filter${ext_vcf}"), path("${vcf_file.simpleName}.filter${ext_vcf}${ext_vcf_index}"), emit: vcf_file)

    script:
        ext_vcf = params.compress || vcf_file.getExtension() == ".gz" ? ".vcf.gz" : ".vcf"
        ext_vcf_index = params.compress || vcf_file.getExtension() == ".gz" ? ".tbi" : ".idx"
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}G" SelectVariants \
        --reference ${params.genome} \
        --variant $vcf_file \
        --output ${vcf_file.simpleName}.snp${ext_vcf} \
        --select-type-to-exclude INDEL

        gatk --java-options "-Xmx${task.memory.toGiga()-4}G" SelectVariants \
        --reference ${params.genome} \
        --variant $vcf_file \
        --output ${vcf_file.simpleName}.indel${ext_vcf} \
        --select-type-to-include INDEL

        gatk --java-options "-Xmx${task.memory.toGiga()-4}G" VariantFiltration \
        --reference ${params.genome} \
        --variant ${vcf_file.simpleName}.snp${ext_vcf} \
        --output ${vcf_file.simpleName}.snp_filter${ext_vcf} \
        ${params.snp_filter} \
        ${params.snp_cluster}

        gatk --java-options "-Xmx${task.memory.toGiga()-4}G" VariantFiltration \
        --reference ${params.genome} \
        --variant ${vcf_file.simpleName}.indel${ext_vcf} \
        --output ${vcf_file.simpleName}.indel_filter${ext_vcf} \
        ${params.indel_filter}

        gatk --java-options "-Xmx${task.memory.toGiga()-4}G" MergeVcfs \
        --INPUT ${vcf_file.simpleName}.snp_filter${ext_vcf} \
        --INPUT ${vcf_file.simpleName}.indel_filter${ext_vcf} \
        --OUTPUT ${vcf_file.simpleName}.filter${ext_vcf}
        """
}
