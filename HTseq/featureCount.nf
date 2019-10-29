process featureCount {
    tag "featureCount"
    publishDir "$params.outdir/${sample}/counts", mode: 'copy'
    cpus 4
    penv 'threaded'
    memory '20 GB'
    time '1h'

    input:
    set val(sample), file(bam)
    
	
    output:
    set val(sample), file("${sample}_read_counts_raw.txt") 

    shell:
    """
    set -o pipefail
    $params.sambamba view $bam | $params.htseq-count -m $params.htseq_count_mode -r pos -s $params.htseq_count_strand -i $params.htseq_count_feature - $params.gtf > ${sample}_read_counts_raw.txt;
    """

}
