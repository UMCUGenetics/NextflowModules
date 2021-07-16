process MergeVcfs {
    tag {"GATK MergeVcfs ${output_name}"}
    label 'GATK_4_2_0_0'
    label 'GATK_4_2_0_0_MergeVcfs'
    container = 'broadinstitute/gatk:4.2.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(output_name, path(vcf_files), path(vcf_idx_files))

    output:
        tuple(output_name, path("${output_name}.vcf"), path("${output_name}.vcf.idx"), emit:vcf_file)

    script:
        def input_files = vcf_files.collect{"$it"}.join(" --INPUT ")
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}G" MergeVcfs --INPUT ${input_files} --OUTPUT ${output_name}.vcf
        """
}


process MergeGvcfs {
    tag {"GATK MergeGvcfs ${output_name}"}
    label 'GATK_4_2_0_0'
    label 'GATK_4_2_0_0_MergeGvcfs'
    container = 'broadinstitute/gatk:4.2.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(output_name, path(vcf_files), path(vcf_idx_files))

    output:
        tuple(output_name, path("${output_name}.g.vcf"), path("${output_name}.g.vcf.idx"), emit:vcf_file)

    script:
        def input_files = vcf_files.collect{"$it"}.join(" --INPUT ")
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}G" MergeVcfs --INPUT ${input_files} --OUTPUT ${output_name}.g.vcf
        """
}
