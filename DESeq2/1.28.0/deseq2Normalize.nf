process Deseq2Normalize {
    tag "deseq2normalize ${run_id}"
    label 'biconductor_1_28_0'
    label 'biconductor_1_28_0_deseq2normalize'
    
    container = 'quay.io/biocontainers/bioconductor-deseq2:1.28.0--r40h5f743cb_0'
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
