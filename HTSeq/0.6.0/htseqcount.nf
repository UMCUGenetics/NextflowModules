process htseqcount {
    tag {"htseq-count ${sample_id}"}
    label 'HTSeq_0_6_0'
    label 'htseq_count_0_6_0'
    container = "/hpc/cog_bioinf/ubec/tools/rnaseq_containers/htseq_0.6.0-squashfs-pack.gz.squashfs" 
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.htseq_mem}" : ""
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, file(sam_file), file(sam_index)

    output:
    tuple sample_id, file("${sample_id}_read_counts_raw.txt") 

    shell:
    """
    htseq-count -m $params.htseq_mode -r pos -s $params.htseq_strandness -i $params.htseq_feature -f $params.htseqsam_format ${sam_file} $params.genome_gtf > ${sample_id}_read_counts_raw.txt;
    """
}
