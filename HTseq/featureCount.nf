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
    set (file "${sample}_read_counts_raw.txt") 

    shell:
    """
    module load python/2.7.10  
    module load sambamcram/sambamba/0.6.5 

    sambamba view $bam | python -m HTSeq.scripts.count -m $params.htseq_count_mode -r pos -s $params.htseq_count_strand -i $params.htseq_count_feature - $params.gtf > ${sample}_read_counts_raw.txt;
    """

}
