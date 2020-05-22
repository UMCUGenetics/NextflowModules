process SplitIntervals {
    tag {"GATK SplitIntervals"}
    label 'GATK_4_1_3_0'
    label 'GATK_4_1_3_0_SplitIntervals'
    container = 'library://sawibo/default/bioinf-tools:gatk4.1.3.0'
    shell = ['/bin/bash', '-euo', 'pipefail']
    input:
        val mode
        path(scatter_interval_list)

    output:
        path("temp_*/scattered.interval_list", emit: interval_lists)

    script:
        break_bands_at_multiples_of = mode == 'break' ? 1000000 : 0

        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\${TMPDIR}" \
        IntervalListTools \
            -I ${scatter_interval_list} \
            ${params.optional} \
          --BREAK_BANDS_AT_MULTIPLES_OF $break_bands_at_multiples_of \
            -O .
        """
}
