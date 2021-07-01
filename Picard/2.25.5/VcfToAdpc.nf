process VcfToAdpc {
    tag {"VcfToAdpc ${sample_id}"}
    label 'PICARD_2_25_5'
    label 'PICARD_2_25_5_VcfToAdpc'
    container = 'quay.io/biocontainers/picard:2.25.5--hdfd78af_0'
    shell = ['/bin/bash', '-euo', 'pipefail']
    
    input:
        tuple (
            val(sample_id),
            path(input_vcf),
            path(input_vcf_index)
        )
    
    output:
        tuple (
            sample_id,
            path("${sample_id}_samples.txt"),
            path("${sample_id}_num_markers.txt"),
            path("${sample_id}_adpc.bin")
        )
    
    script:
    // params.optional could contain an additional VCF for contamination_controls_vcf.
        """
        picard "-Xmx${task.memory.toGiga()-4}G" -Dpicard.useLegacyParser=false \
        VcfToAdpc \
        --VCF ${input_vcf} \
        --SAMPLES_FILE ${sample_id}_samples.txt \
        --NUM_MARKERS_FILE ${sample_id}_num_markers.txt \
        --OUTPUT ${sample_id}_adpc.bin \
        ${params.optional}
        """
}