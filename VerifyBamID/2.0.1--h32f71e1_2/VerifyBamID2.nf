process VerifyBamID2 {
    tag {"VerifyBamID2 ${sample_id}"}
    label 'VERIFYBAMID_2_0_1_h32f71e1_2'
    label 'VERIFYBAMID_2_0_1_h32f71e1_2_VerifyBamID2'
    container = 'quay.io/biocontainers/verifybamid2:2.0.1--h32f71e1_2'
    shell = ['/bin/bash', '-eo', 'pipefail']

    input:
        tuple (sample_id, path(bam), path(bai))

    output:
        tuple (sample_id, path("${output_prefix}.selfSM"))

    script:
        output_prefix = "${sample_id}.contamination"

        """
        # creates a ${output_prefix}.selfSM file, a TSV file with 2 rows, 19 columns.
        # First row are the keys (e.g., SEQ_SM, RG, FREEMIX), second row are the associated values
        verifybamid2 \
        --Reference ${params.genome} \
        --BamFile ${bam} \
        --SVDPrefix ${params.contamination_path_prefix} \
        --UDPath ${params.contamination_sites_ud} \
        --MeanPath ${params.contamination_sites_mu} \
        --BedPath ${params.contamination_sites_bed} \
        --Verbose \
        --NumPC 4 \
        --NumThread ${task.cpus} \
        --Output  ${output_prefix}
        """
}
