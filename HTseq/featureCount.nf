        
process feature_count {
    tag "${sample}_featureCount"
    publishDir "$params.outdir/$sample/HTseq", mode: 'copy'
    cpus 2
    penv 'threaded'
    memory '1 GB'
    time '1h'

    input:
    set val(sample), file(bam)
    file index 

    output:
    file "${sample}_counts_raw.txt" 

    shell:
    """
    python -m $params.htseq/HTSeq.scripts.count -m union -r pos -s $params.strandness -i gene_id  $params.gtf > ${sample}_counts_raw.txt;
    """

}