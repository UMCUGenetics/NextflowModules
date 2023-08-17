process FilterPairs {
    tag {"duplex_tools FilterPairs ${sample_id}"}
    label 'duplex_tools'
    label 'duplex_tools_FilterPairs'
    container = 'quay.io/biocontainers/duplex-tools:0.2.17--pyh7cba7a3_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        path(read_pairs)
        tuple(val(sample_id), path(bam_file), path(bai_file))

    output:
        path("duplex_reads.txt")

    script:
        """
        duplex_tools filter_pairs ${read_pairs} ./
        cut -d ' ' -f 2 pair_ids_filtered.txt > duplex_reads.txt
        """
}
