process QuantMerge {
    tag {"Salmon QuantMerge ${sample_id}"}
    label 'Salmon_1_2_1'
    label 'Salmon_1_2_1_QuantMerge'
    container = 'quay.io/biocontainers/salmon:1.2.1--hf69c8f4_0'
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

