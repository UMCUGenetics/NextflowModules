process CollectMultipleMetrics {
    tag {"PICARD CollectMultipleMetrics ${sample_id}"}
    label 'PICARD_2_26_4'
    label 'PICARD_2_26_4_CollectMultipleMetrics'
    container = 'quay.io/biocontainers/picard:2.26.4--hdfd78af_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(bam_file), path(bai_file))

    output:
        path("*.txt", emit: txt_files)

    script:
        """
        picard -Xmx${task.memory.toGiga()-4}G CollectMultipleMetrics TMP_DIR=\$TMPDIR R=${params.genome} INPUT=${bam_file} OUTPUT=${sample_id} EXT=.txt ${params.optional}
        """
}

