process Deseq2Normalize {
    tag "deseq2normalize ${run_id}"
    label 'biconductor_1_38_0'
    label 'biconductor_1_38_0_deseq2normalize'
    
    container = 'quay.io/biocontainers/bioconductor-deseq2:1.38.0--r42hc247a5b_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        val(run_id)
        file(counts)

    output:
        file("${run_id}_featureCounts_deseq2.txt")
   
    script:
        """
        deseq2Normalize.R ${counts} ${run_id}  
        """
}
