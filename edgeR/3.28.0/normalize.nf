process EdgerNormalize {
    tag "edger_normalize ${run_id}"
    label 'biconductor_3_20_7'
    label 'biconductor_3_20_7_edger_normalize'
    container = 'quay.io/biocontainers/bioconductor-edger:3.20.7--r3.4.1_0'
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
