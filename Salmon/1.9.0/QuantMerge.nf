process QuantMerge {
    tag {"Salmon QuantMerge ${run_name}"}
    label 'Salmon_1_9_0'
    label 'Salmon_1_9_0_QuantMerge'
    container = 'quay.io/biocontainers/salmon:1.9.0--h7e5ed60_1'
    shell = ['/bin/bash', '-euo', 'pipefail']
    
    input:
        val(run_name)
        path(quant_dirs)
   
    output:
        path("*.txt", emit: quant_tables_merged)

    script:
        def quants = quant_dirs.collect{ "$it" }.join(",")
        """  
        salmon quantmerge --column numreads --quants {${quants}} -o ${run_name}_transcripts_quantmerge_numReads.txt 
        salmon quantmerge --column tpm --quants {${quants}} -o ${run_name}_transcripts_quantmerge_TPM.txt  
        salmon quantmerge --column len --quants {${quants}} -o ${run_name}_transcripts_quantmerge_Length.txt
        salmon quantmerge --column elen --quants {${quants}} -o ${run_name}_transcripts_quantmerge_EffectiveLength.txt
        """
}

