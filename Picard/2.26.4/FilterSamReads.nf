process FilterSamReads {
    tag {"PICARD FilterSamReads ${bam_file}"}
    label 'PICARD_2_26_4'
    label 'PICARD_2_26_4_FilterSamReads'
    container = 'quay.io/biocontainers/picard:2.26.4--hdfd78af_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(path(bam_file), path(bai_file))
        path(duplex_reads)

    output:
        path("${bam_file.baseName}_filtered.bam", emit: duplex_filter_bam)

    script:
        """
        picard -Xmx${task.memory.toGiga()-4}G FilterSamReads TMP_DIR=\$TMPDIR INPUT=${bam_file} OUTPUT=${bam_file.baseName}_filtered.bam READ_LIST_FILE=${duplex_reads} ${params.optional}
        """
}
