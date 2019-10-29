        
process kallisto_quant {
    tag "${sample}_Kallisto"
    publishDir "$params.outdir/$sample/$params.process_outdir", mode: 'copy'
    publishDir "$params.outdir/$sample/Kallisto_quant", mode: 'copy'

    input:
    set val(sample), file(r1_fastqs), file(r2_fastqs)
    file index 

    output:
    file "kallisto_${sample}/abundance.tsv"
    file "kallisto_${sample}/abundance.h5"
    file "kallisto_${sample}/run_info.json"

    script:
    """
    cat $r1_fastqs > ${sample}_R1.fq.gz 
    cat $r2_fastqs > ${sample}_R2.fq.gz 

    $params.kallisto quant -i $kallisto_index -t $task.cpus -o kallisto_${sample} ${sample}_R1.fq.gz ${sample}_R2.fq.gz 
    """

}