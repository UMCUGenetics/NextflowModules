process mergeHtseqCounts {
    tag { "mergehtseqcounts" }
    label 'mergehtseqcounts'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    val run_id
    file(count_tables)

    output:
    file("${run_id}_readCounts_raw.txt")

    script:
    """
    mergeHtseqCounts.R \$PWD $run_id 
    """

}
