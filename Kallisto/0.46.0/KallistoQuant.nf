        
process kallisto_quant {
    tag "${sample}_Kallisto"
    publishDir "$params.outdir/$sample/$params.process_outdir", mode: 'copy'
    cpus 2
    penv 'threaded'
    memory '1 GB'
    time '1h'

    input:
    set val(sample), file(r1_fastqs), file(r2_fastqs)
    file index 

    output:
    file "kallisto_${sample}" 

    script:
    """
    cat $r1_fastqs > ${sample}_R1.fq.gz 
    cat $r2_fastqs > ${sample}_R2.fq.gz 

    $params.kallisto quant -i $index -t $task.cpus -o kallisto_${sample} ${sample}_R1.fq.gz ${sample}_R2.fq.gz 
    """

}