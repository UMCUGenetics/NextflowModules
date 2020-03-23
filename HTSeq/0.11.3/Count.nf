process Count {
    tag {"HTSeq Count ${sample_id}"}
    label 'HTSeq_0_11_3'
    label 'HTSeq_0_11_3_Count'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'quay.io/biocontainers/htseq:0.11.3--py37hb3f55d8_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, file(bam_file), file(bai)
    file(genome_gtf)   
  
    output:
    tuple sample_id, file("${sample_id}_readCounts_raw.txt") 

    shell:
    def s_val = 'no'
    if (params.stranded && !params.unstranded) {
       sval = params.singleEnd ? 'yes' : 'reverse'
    }
    if (params.revstranded && !params.unstranded) {
       sval = params.singleEnd ? 'reverse' : 'yes'  
    } 
         
    """
    htseq-count ${params.optional} -s ${s_val} -f bam ${bam_file} ${genome_gtf}  > ${sample_id}_readCounts_raw.txt
    """
}
