        
process featureCount {
    tag "featureCount"
    publishDir "$params.outdir/bla/HTseq", mode: 'copy'
    cpus 2
    penv 'threaded'
    memory '1 GB'
    time '1h'

    input:
    set file(bam:"*")
    output:
    file "read_counts_raw.txt" 

    shell:
    """
    $params.sambama view $bam | python -m HTSeq.scripts.count -m union -r pos -s yes -i gene_id - $params.gtf > read_counts_raw.txt;
    """

}