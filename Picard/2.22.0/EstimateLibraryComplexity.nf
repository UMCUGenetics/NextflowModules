process EstimateLibraryComplexity {
    tag {"PICARD EstimateLibraryComplexity ${sample_id}"}
    label 'PICARD_2_22_0'
    label 'PICARD_2_22_0_EstimateLibraryComplexity'
    container = 'quay.io/biocontainers/picard:2.22.0--0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple val(sample_id), file(bam_file), file(bai_file)

    output:
    tuple val(sample_id), file("${sample_id}.LibraryComplexity.txt")

    script:

    """
    picard -Xmx${task.memory.toGiga()-4}G EstimateLibraryComplexity TMP_DIR=\$TMPDIR INPUT=$bam_file OUTPUT=${sample_id}.LibraryComplexity.txt
    """
}
