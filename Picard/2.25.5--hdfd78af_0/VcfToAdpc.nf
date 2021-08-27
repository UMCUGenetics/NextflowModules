process VcfToAdpc {
    tag {"VcfToAdpc ${identifier}"}
    label 'PICARD_2_25_5_hdfd78af_0'
    label 'PICARD_2_25_5_hdfd78af_0_VcfToAdpc'
    container = 'quay.io/biocontainers/picard:2.25.5--hdfd78af_0'
    shell = ['/bin/bash', '-euo', 'pipefail']
    
    input:
        tuple (
            val(identifier),
            path(input_vcf),
            path(input_vcf_index),
        )
    
    output:
        tuple (
            identifier,
            path("${identifier}_samples.txt"),
            path("${identifier}_num_markers.txt"),
            path("${identifier}_adpc.bin")
        )
    
    script:
    // params.optional could contain an additional VCF for contamination_controls_vcf.
        """
        picard "-Xmx${task.memory.toGiga()-4}G" -Dpicard.useLegacyParser=false \
        VcfToAdpc \
        --VCF ${input_vcf} \
        --SAMPLES_FILE ${identifier}_samples.txt \
        --NUM_MARKERS_FILE ${identifier}_num_markers.txt \
        --OUTPUT ${identifier}_adpc.bin \
        ${params.optional}
        """
}