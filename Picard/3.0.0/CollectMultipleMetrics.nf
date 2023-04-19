process CollectMultipleMetrics {
    tag {"PICARD CollectMultipleMetrics ${sample_id}"}
    label 'PICARD_3_0_0'
    label 'PICARD_3_0_0_CollectMultipleMetrics'
    container = 'quay.io/biocontainers/picard:3.0.0--hdfd78af_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam_file), path(bai_file))

    output:
        path("*.txt", emit: txt_files)

    script:
        """
        picard -Xmx${task.memory.toGiga()-4}G CollectMultipleMetrics --TMP_DIR \$TMPDIR \
        --REFERENCE_SEQUENCE ${params.genome} \
        --INPUT ${bam_file} \
        --OUTPUT ${sample_id} \
        --FILE_EXTENSION .txt \
        ${params.optional}
        """
}
