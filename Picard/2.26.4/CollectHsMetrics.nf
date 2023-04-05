process CollectHsMetrics {
    tag {"PICARD CollectHsMetrics ${sample_id}"}
    label 'PICARD_2_26_4'
    label 'PICARD_2_26_4_CollectHsMetrics'
    container = 'quay.io/biocontainers/picard:2.26.4--hdfd78af_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(bam_file), path(bai_file))

    output:
        path("${sample_id}.HsMetrics.txt", emit: txt_file)

    script:
        """
        picard -Xmx${task.memory.toGiga()-4}G CollectHsMetrics TMP_DIR=\$TMPDIR R=${params.genome} INPUT=${bam_file} OUTPUT=${sample_id}.HsMetrics.txt BAIT_INTERVALS=${params.bait} TARGET_INTERVALS=${params.target} ${params.optional}
        """
}
