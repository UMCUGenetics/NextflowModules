process Count {
    tag {"HTSeq Count ${sample_id}"}
    label 'HTSeq_0_11_3'
    label 'HTSeq_0_11_3_Count'
    container = 'quay.io/biocontainers/htseq:0.11.3--py37hb3f55d8_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(bam_file), path(bai_file))
        path(genome_gtf)   
  
    output:
        tuple(sample_id, path("${sample_id}_readCounts_raw.txt"), emit: count_table) 

    script:
        def s_val = 'no'
        if (params.stranded && !params.unstranded) {
            s_val = 'yes'
        } else if (params.revstranded && !params.unstranded) {
            s_val = 'reverse'   
        } 
        """
        htseq-count ${params.optional} -s ${s_val} -t ${params.hts_count_type} -i ${params.hts_group_features} -f bam ${bam_file} ${genome_gtf}  > ${sample_id}_readCounts_raw.txt
        """
}
