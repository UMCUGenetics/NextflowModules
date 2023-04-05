process IntervalListTools {
    tag {"PICARD IntervalListTools"}
    label 'PICARD_2_26_4'
    label 'PICARD_2_26_4_IntervalListTools'
    container = 'quay.io/biocontainers/picard:2.26.4--hdfd78af_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        path(interval_list)

    output:
        path("temp_*/*.interval_list", emit: interval_list)

    script:
        """
        picard -Xmx${task.memory.toGiga()-4}G IntervalListTools TMP_DIR=\$TMPDIR \
        INPUT=${interval_list} OUTPUT=. \
        SUBDIVISION_MODE=BALANCING_WITHOUT_INTERVAL_SUBDIVISION_WITH_OVERFLOW \
        SCATTER_COUNT=${params.scatter_count} \
        UNIQUE=true \
        ${params.optional}
        
        for folder in temp*; do mv \$folder/scattered.interval_list \$folder/\$folder\\.interval_list; done
        """
}
