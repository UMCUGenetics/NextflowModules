process htseq-count {
    tag "${sample}_htseq-count"
    publishDir "$params.outdir/${sample}/htseq-count", mode: 'copy'
    input:
    set val(sample), file(bam)

    output:
    set val(sample), file("${sample}_read_counts_raw.txt") 

    shell:
    """
    $params.htseq-count -m $params.htseq-count_mode -r pos -s $params.htseq-count_strand -i $params.htseq-count_feature - $params.genome_gtf > ${sample}_read_counts_raw.txt;
    """

}
