process CollectHsMetrics {
    tag {"PICARD CollectHsMetrics ${sample_id} - ${rg_id}"}
    label 'PICARD_2_22_0'
    label 'PICARD_2_22_0_CollectHsMetrics'
    container = 'quay.io/biocontainers/picard:2.22.0--0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple val(sample_id), file(bam_file), file(bai_file)

    output:
    tuple val(sample_id), file("${sample_id}.HsMetrics.txt")

    script:

    """
    picard -Xmx${task.memory.toGiga()-4}G CollectHsMetrics R=$params.genome INPUT=$bam_file OUTPUT=${sample_id}.HsMetrics.txt BAIT_INTERVALS=$params.bait TARGET_INTERVALS=$params.target $params.optional
    """
}
