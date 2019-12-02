process htseq-count {
    tag {"htseq-count ${sample_id} - ${rg_id}"}
    label 'htseq-count_0_6_0'  

    input:
    tuple sample_id, file(bam_file)

    output:
    tuple sample_id, file("${sample_id}_read_counts_raw.txt") 

    shell:
    """
    htseq-count -m $params.htseq-count_mode -r pos -s $params.htseq-count_strandness -i $params.htseq-count_feature -f bam ${bam_file} $params.genome_gtf > ${sample}_read_counts_raw.txt;
    """

}
