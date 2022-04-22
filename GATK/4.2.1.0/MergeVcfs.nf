process MergeVcfs {
    tag {"GATK MergeVcfs ${output_name}"}
    label 'GATK_4_2_1_0'
    label 'GATK_4_2_1_0_MergeVcfs'
    container = 'broadinstitute/gatk:4.2.1.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(output_name, path(vcf_files), path(vcf_idx_files))

    output:
        tuple(output_name, path("${output_name}${ext_vcf}"), path("${output_name}${ext_vcf}${ext_vcf_index}"), emit:vcf_file)

    script:
        def input_files = vcf_files.collect{"$it"}.join(" --INPUT ")
        ext_vcf = ".vcf"
        ext_vcf_index = ".idx"
        if( params.compress )
            ext_vcf = ".vcf.gz"
            ext_vcf_index = ".tbi"
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}G" MergeVcfs --INPUT ${input_files} --OUTPUT ${output_name}${ext_vcf}
        """
}


process MergeGvcfs {
    tag {"GATK MergeGvcfs ${output_name}"}
    label 'GATK_4_2_1_0'
    label 'GATK_4_2_1_0_MergeGvcfs'
    container = 'broadinstitute/gatk:4.2.1.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(output_name, path(vcf_files), path(vcf_idx_files))

    output:
        tuple(output_name, path("${output_name}${ext_gvcf}"), path("${output_name}${ext_gvcf}${ext_gvcf_index}"), emit:vcf_file)

    script:
        def input_files = vcf_files.collect{"$it"}.join(" --INPUT ")
        ext_gvcf = ".g.vcf"
        ext_gvcf_index = ".idx"
        if( params.compress )
            ext_gvcf = ".g.vcf.gz"
            ext_gvcf_index = ".tbi"
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}G" MergeVcfs --INPUT ${input_files} --OUTPUT ${output_name}${ext_gvcf}
        """
}
