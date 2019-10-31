process SplitIntervals {
    tag {"SplitIntervals"}
    label 'GATK'
    input:
      val mode
      file(scatter_interval_list)

    output:
      file "temp_*/scattered.interval_list"

    script:

    break_bands_at_multiples_of = mode == 'break' ? 1000000 : 0

    """
    gatk --java-options -Xmx${task.memory.toGiga()}g \
    IntervalListTools \
  		-I ${scatter_interval_list} \
  		-M BALANCING_WITHOUT_INTERVAL_SUBDIVISION_WITH_OVERFLOW \
  		--SCATTER_COUNT $params.scatter_count \
      --UNIQUE true \
      --BREAK_BANDS_AT_MULTIPLES_OF $break_bands_at_multiples_of \
  		-O .

    """
}
