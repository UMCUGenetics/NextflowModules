process EdgerNormalize {
    tag "edger_normalize ${run_id}"
    label 'biconductor_3_40_0'
    label 'biconductor_3_40_0_edger_normalize'
    container = 'quay.io/biocontainers/bioconductor-edger:3.40.0--r42hc247a5b_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        val(run_id)
        file(counts)

    output:
        file("${run_id}_featureCounts_RPKM.txt")
        file("${run_id}_featureCounts_CPM.txt")

    script:
        """
        edgerNormalize.R ${counts} ${run_id}   
        """
}