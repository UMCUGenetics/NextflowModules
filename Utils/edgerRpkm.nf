process edger_rpkm {
    tag "bioconductor_edger_rpkm ${run_id}"
    label 'biconductor_3.28.0'
    label 'biconductor_3.28.0_edger_rpkm'
    
    container = 'quay.io/biocontainers/bioconductor-edger:3.28.0--r36he1b5a44_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    val run_id
    file(counts)
    val feature_lengths

    output:
    file("${run_id}_readCounts_RPKM.txt")

    script:
    """
    edgerRpkm.R ${run_id} ${counts} ${feature_lengths}  
    """

}
