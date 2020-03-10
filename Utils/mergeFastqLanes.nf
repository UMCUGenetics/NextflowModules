process mergeFastqLanes {
    tag {"mergeFastqLanes ${sample_id}"}
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, file(r1_fastqs), file(r2_fastqs)

    output:
    tuple sample_id, file("*")


    script:
    if (params.singleEnd) {
        def r1 = r1_fastqs.collect{ "$it" }.join(" ")
        """
        zcat ${r1} > ${sample_id}.R1.fastq.gz
        """
    } else {
      def r1 = r1_fastqs.collect{ "$it" }.join(" ") 
      def r2 = r2_fastqs.collect{ "$it" }.join(" ")
      """
      cat ${r1} > ${sample_id}.R1.fastq.gz
      cat ${r2} > ${sample_id}.R2.fastq.gz
      """
    }
}

