process EstimateLibraryComplexity {
    tag {"PICARD EstimateLibraryComplexity ${sample_id}"}
    label 'PICARD_2_27_5'
    label 'PICARD_2_27_5_EstimateLibraryComplexity'
    container = 'quay.io/biocontainers/picard:2.27.5--hdfd78af_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam_file), path(bai_file))

    output:
        path("${sample_id}.LibraryComplexity.txt", emit: txt_file)

    script:
        """
        picard -Xmx${task.memory.toGiga()-4}G -Djava.io.tmpdir=\$TMPDIR EstimateLibraryComplexity \
        TMP_DIR=\$TMPDIR \
        INPUT=${bam_file} \
        OUTPUT=${sample_id}.LibraryComplexity.txt \
        ${params.optional}
        """
}
