process QuantMerge {
    tag {"Salmon QuantMerge ${run_name}"}
    label 'Salmon_1_2_1'
    label 'Salmon_1_2_1_QuantMerge'
    container = 'quay.io/biocontainers/salmon:1.2.1--hf69c8f4_0'
    shell = ['/bin/bash', '-euo', 'pipefail']
    
    input:
        val(run_name)
        path(quant_dirs)
   
    output:
        path("*.txt", emit: quant_tables_merged)

    script:
        def quants = quant_dirs.collect{ "$it" }.join(",")
        """  
        salmon quantmerge -c numreads --quants {${quants}} -o ${run_name}_transcripts_quantmerge_numReads.txt 
        salmon quantmerge -c tpm --quants {${quants}} -o ${run_name}_transcripts_quantmerge_TPM.txt  
        salmon quantmerge -c len --quants {${quants}} -o ${run_name}_transcripts_quantmerge_Length.txt
        salmon quantmerge -c elen --quants {${quants}} -o ${run_name}_transcripts_quantmerge_EffectiveLength.txt
        """
}

