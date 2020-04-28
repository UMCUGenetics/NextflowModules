process QuantMerge {
    tag {"Salmon QuantMerge ${sample_id}"}
    label 'Salmon_0_13_1'
    label 'Salmon_0_13_1_QuantMerge'
    container = 'quay.io/biocontainers/salmon:0.13.1--h86b0361_0'
    shell = ['/bin/bash', '-euo', 'pipefail']
    
    input:
    file(quant_dirs)
    val run_name
    
   
    output:
    file("*_quantmerge_{numReads,TPM}.txt")

    script:
    def quants = quant_dirs.collect{ "$it" }.join(",")
    """
    salmon quantmerge -c numreads --quants {${quants}} -o ${run_name}_genes_quantmerge_numReads.txt  
    salmon quantmerge -c numreads --quants {${quants}} -o ${run_name}_transcripts_quantmerge_numReads.txt 
    salmon quantmerge -c tpm --quants {${quants}} --genes -o ${run_name}_genes_quantmerge_TPM.txt  
    salmon quantmerge -c tpm --quants {${quants}} -o ${run_name}_transcripts_quantmerge_TPM.txt  
    """
}

