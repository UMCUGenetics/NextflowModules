process htseqcount {
    tag {"htseq-count ${sample_id}"}
    label 'HTSeq_0_6_0'
    label 'HTSeq_0_6_0_count'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.htseq_mem}" : ""
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, file(bam), file(bai)

    output:
    tuple sample_id, file("${sample_id}_read_counts_raw.txt") 

    shell:
    """
    htseq-count -m $params.htseq_mode -r pos -s $params.htseq_strandness -i $params.htseq_feature -f bam ${bam} $params.genome_gtf > ${sample_id}_read_counts_raw.txt;
    """
}
