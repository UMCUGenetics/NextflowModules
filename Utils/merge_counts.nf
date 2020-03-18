process merge_counts {
    tag { "merge_counts" }
    label 'merge_counts'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    val run_id
    file(count_tables)

    output:
    file("${run_id}_counts_merged.txt")

    script:
    """
    merge_counts.R \$PWD $run_id 
    """

}
