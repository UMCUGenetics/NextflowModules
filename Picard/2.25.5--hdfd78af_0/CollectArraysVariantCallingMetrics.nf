process CollectArraysVariantCallingMetrics {
    tag {"CollectArraysVariantCallingMetrics ${identifier}"}
    label 'PICARD_2_25_5_hdfd78af_0'
    label 'PICARD_2_25_5_hdfd78af_0_CollectArraysVariantCallingMetrics'
    container = 'quay.io/biocontainers/picard:2.25.5--hdfd78af_0'
    shell = ['/bin/bash', '-euo', 'pipefail']
    
    input:
        tuple (
            val(identifier),
            path(input_vcf),
            path(input_vcf_index)
        )
    output:
        tuple(
            path("${output_prefix}.arrays_variant_calling_summary_metrics"),
            path("${output_prefix}.arrays_variant_calling_detail_metrics"),
            path("${output_prefix}.arrays_control_code_summary_metrics"),
            path("pass.txt")
        )

    script:
        output_prefix = params.output_prefix ? identifier + params.output_prefix : identifier + "_VC_metrics"

        """
        picard -Xmx!{task.memory.toGiga()-4}G \
        CollectArraysVariantCallingMetrics \
        --TMP_DIR \$TMPDIR \
        --INPUT ${input_vcf} \
        --OUTPUT ${output_prefix} \
        --DBSNP ${params.dbsnp} \
        --CALL_RATE_PF_THRESHOLD ${params.call_rate_threshold}
        """
}