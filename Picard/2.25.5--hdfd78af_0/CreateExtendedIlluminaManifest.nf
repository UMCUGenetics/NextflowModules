process CreateExtendedIlluminaManifest {
    label 'PICARD_2_25_5_hdfd78af_0'
    label 'PICARD_2_25_5_hdfd78af_0_CreateExtendedIlluminaManifest'
    container = 'quay.io/biocontainers/picard:2.25.5--hdfd78af_0'
    shell = ['/bin/bash', '-euo', 'pipefail']
    
    input:
        val(output_name)
    
    output:
        tuple(path("${output_name}.csv"), path("${output_name}.report"))

    script:
        """
        picard -Xmx${task.memory.toGiga()-4}G \
        CreateExtendedIlluminaManifest \
        --TMP_DIR \$TMPDIR \
        --INPUT ${params.bead_pool_manifest_file_csv} \
        --OUTPUT ${output_name}.csv \
        --REFERENCE_SEQUENCE ${params.genome} \
        --REPORT_FILE ${output_name}.report \
        --CLUSTER_FILE ${params.cluster_file} \
        --MAX_RECORDS_IN_RAM 100000 \
        ${params.optional}
        """
}
