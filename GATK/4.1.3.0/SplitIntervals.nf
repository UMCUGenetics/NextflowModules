process SplitIntervals {
    tag {"SplitIntervals"}
    label 'GATK'
    input:
      file scatter_interval_list

    output:
      file "scatter/*-scattered.interval_list"

    script:

    """
    gatk --java-options -Xmx${task.memory.toGiga()}g \
    SplitIntervals \
      -R $params.genome_fasta \
  		-L ${scatter_interval_list} \
  		--subdivision-mode BALANCING_WITHOUT_INTERVAL_SUBDIVISION \
  		--scatter-count 30 \
  		-O scatter
    """
}
