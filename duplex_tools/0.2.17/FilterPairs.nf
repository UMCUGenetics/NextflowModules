process FilterPairs {
    tag {"Duplex_Tools FilterPairs ${bam_file}"}
    label 'Duplex_Tools'
    label 'Duplex_Tools_FilterPairs'
    container = 'quay.io/biocontainers/duplex-tools:0.2.17--pyh7cba7a3_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        path(read_pairs)
        tuple(path(bam_file), path(bai_file))

    output:
        path("duplex_reads.txt")

    script:
        """
        duplex_tools filter_pairs ${read_pairs} ./
        cut -d ' ' -f 2 pair_ids_filtered.txt > duplex_reads.txt
        """
}
