process Count {
    tag {"HTSeq Count ${sample_id}"}
    label 'HTSeq_0_6_0'
    label 'HTSeq_0_6_0_Count'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.htseq_mem}" : ""
    container = '/hpc/local/CentOS7/cog_bioinf/nextflow_containers/HTSeq/htseq_0.6.0-squashfs-pack.gz.squashfs'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, file(bam_file), file(bai)
    file(genome_gtf)   
  
    output:
    tuple sample_id, file("${sample_id}_*_raw_counts.txt") 

    shell:

    def s_val = ''
    if (params.stranded && !params.unstranded) {
       sval = params.singleEnd ? 'yes' : 'reverse'
    } else if (params.revstranded && !params.unstranded) {
         sval = params.singleEnd ? 'reverse' : 'yes'  
    } else {
         sval = 'no'    
    }

    """
    htseq-count ${params.count.toolOptions} -s $s_val -f bam $bam_file $genome_gtf  > ${sample_id}_raw_counts.txt
    """
}
