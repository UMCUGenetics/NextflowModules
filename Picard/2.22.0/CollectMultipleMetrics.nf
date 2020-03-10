process CollectMultipleMetrics {
    tag {"PICARD CollectMultipleMetrics ${sample_id} - ${rg_id}"}
    label 'PICARD_2_22_0'
    label 'PICARD_2_22_0_CollectMultipleMetrics'
    container = 'quay.io/biocontainers/picard:2.22.0--0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple val(sample_id), file(bam_file), file(bai_file)

    output:
    tuple val(sample_id), file("*.txt")

    script:

    """
    picard -Xmx${task.memory.toGiga()-4}G CollectMultipleMetrics R=$params.genome INPUT=$bam_file OUTPUT=${sample_id} EXT=.txt $params.optional
    """
}
