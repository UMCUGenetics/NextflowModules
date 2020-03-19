process edger_rpkm {
    tag { "edger_rpkm" }
    label 'edger_rpkm'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    val run_id
    file(counts)
    val feature_lengths

    output:
    file("${run_id}_RPKM.txt")

    script:
    """
    edger_rpkm.R ${run_id} ${counts} ${feature_lengths}  
    """

}
