process calculateExpression {
    tag "${sample}_RSEM"
    publishDir "$params.outdir/$sample/RSEM", mode: 'copy'
    cpus 8  
    penv 'threaded'
    memory '10 GB'
    time '1h'

    input:
    set sample, file(r1_fastq), file(r2_fastq)
    file(index)

    output:
    ("*.genes.results")
    ("*.isoform.results")
    ("*.stats")
    file ("*.bam")
    file ("*.bai")

    script:
    """
    $params.rsem/rsem-calculate-expression -p $task.cpus --star --star-path $params.star --paired-end -estimate-rspd --append-names --output-genome-bam $r1_fastq $r2_fastq $index $sample
    """
}
