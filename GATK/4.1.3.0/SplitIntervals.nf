process SplitIntervals {
    tag {"GATK_Splitintervals"}
    label 'GATK_4_1_3_0'
    label 'GATK_4_1_3_0_Splitintervals'
    container = 'library://sawibo/default/bioinf-tools:gatk4.1.3.0'

    input:
      val mode
      file(scatter_interval_list)

    output:
      file("temp_*/scattered.interval_list")

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
