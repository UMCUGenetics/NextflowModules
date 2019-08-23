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
    module load python/2.7.10  
    module load sambamcram/sambamba/0.6.5 

    sambamba view $bam | python -m HTSeq.scripts.count -m $params.htseq_count_mode -r pos -s $params.htseq_count_strand -i $params.htseq_count_feature - $params.gtf > ${sample}_read_counts_raw.txt;
    """

}
