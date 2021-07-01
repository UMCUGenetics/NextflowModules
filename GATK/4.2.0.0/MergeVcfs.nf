process MergeVcfs {
    tag {"GATK MergeVcfs ${analysis_id}"}
    label 'GATK_4_2_0_0'
    label 'GATK_4_2_0_0_MergeVcfs'
    container = 'broadinstitute/gatk:4.2.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(analysis_id, path(vcf_files), path(vcf_idx_files))

    output:
        tuple(analysis_id, path("${analysis_id}.vcf"), path("${analysis_id}.vcf.idx"), emit:vcf_file)

    script:
        def input_files = vcf_files.collect{"$it"}.join(" --INPUT ")
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}G" MergeVcfs --INPUT ${input_files} --OUTPUT ${analysis_id}.vcf
        """
}