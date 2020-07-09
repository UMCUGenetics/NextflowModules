process EstimateLibraryComplexity {
    tag {"PICARD EstimateLibraryComplexity ${sample_id}"}
    label 'PICARD_2_22_0'
    label 'PICARD_2_22_0_EstimateLibraryComplexity'
    container = 'quay.io/biocontainers/picard:2.22.0--0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(bam_file), path(bai_file))

    output:
        path("${sample_id}.LibraryComplexity.txt", emit: txt_file)

    script:
        """
        picard -Xmx${task.memory.toGiga()-4}G EstimateLibraryComplexity TMP_DIR=\$TMPDIR INPUT=${bam_file} OUTPUT=${sample_id}.LibraryComplexity.txt ${params.optional}
        """
}
