process MergeFastqLanes {
    tag {"MergeFastqLanes ${sample_id} - ${rg_id}"}
    label 'MergeFastqLanes'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, rg_id, path(r1_fastqs), path(r2_fastqs))

    output:
        tuple(sample_id, path("${sample_id}_${rg_id}_*.fastq.gz"), emit: fastqs_merged)


    script:
        if (params.singleEnd) {
            r1 = r1_fastqs.collect{ "$it" }.join(" ")
            """
            cat ${r1} > ${sample_id}_${rg_id}_R1.fastq.gz
            """
        } else {
            r1 = r1_fastqs.collect{ "$it" }.join(" ")
            r2 = r2_fastqs.collect{ "$it" }.join(" ")
          
            """
            cat ${r1} > ${sample_id}_${rg_id}_R1.fastq.gz
            cat ${r2} > ${sample_id}_${rg_id}_R2.fastq.gz
            """
        }
}

