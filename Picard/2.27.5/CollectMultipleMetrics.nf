process CollectMultipleMetrics {
    tag {"PICARD CollectMultipleMetrics ${sample_id}"}
    label 'PICARD_2_27_5'
    label 'PICARD_2_27_5_CollectMultipleMetrics'
    container = 'quay.io/biocontainers/picard:2.27.5--hdfd78af_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam_file), path(bai_file))

    output:
        path("*.txt", emit: txt_files)

    script:
        """
        picard -Xmx${task.memory.toGiga()-4}G -Djava.io.tmpdir=\$TMPDIR CollectMultipleMetrics \
        TMP_DIR=\$TMPDIR \
        R=${params.genome} \
        INPUT=${bam_file} \
        OUTPUT=${sample_id} \
        EXT=.txt \
        ${params.optional}
        """
}
