        
process quant {
     tag {"Kallisto_quant ${sample_id}"}
     label 'Kallisto_quant_0_46'  

    input:
    tuple sample_id, file(r1_fastqs), file(r2_fastqs)
    file(index) 

    output:
    tuple sample_id,
    file ("kallisto_${sample_id}/abundance.tsv"),
    file ("kallisto_${sample_id}/abundance.h5"),
    file ("kallisto_${sample_id}/run_info.json")

    script:
    """
    cat $r1_fastqs > ${sample_id}_R1.fq.gz 
    cat $r2_fastqs > ${sample_id}_R2.fq.gz 

    $params.kallisto quant -i $kallisto_index -t $params.kallisto_cores -o kallisto_${sample_id} ${sample_id}_R1.fq.gz ${sample_id}_R2.fq.gz 
    """

}
