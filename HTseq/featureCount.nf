        
process featureCount {
    tag "featureCount"
    publishDir "$params.outdir/${sample}/HTseq", mode: 'copy'
    cpus 2
    penv 'threaded'
    memory '20 GB'
    time '1h'

    input:
    set sample, file(bam)
    
	
    output:
    file "${sample}_read_counts_raw.txt" 

    shell:
    """
    samtools view $bam | python -m HTSeq.scripts.count -m union -r pos -s reverse -i gene_id - $params.gtf > ${sample}_read_counts_raw.txt;
    """

}
