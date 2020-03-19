process edgerRpkm {
    tag { "edgerrpkm" }
    label 'edgerrpkm'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    val run_id
    file(counts)
    val feature_lengths

    output:
    file("${run_id}_readCounts_RPKM.txt")

    script:
    """
    edger_rpkm.R ${run_id} ${counts} ${feature_lengths}  
    """

}
