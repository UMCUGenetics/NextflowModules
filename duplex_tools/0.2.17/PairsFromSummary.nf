process PairsFromSummary {
    tag {"Duplex_Tools PairsFromSummary ${sample_id}"}
    label 'Duplex_Tools'
    label 'Duplex_Tools_PairsFromSummary'
    container = 'quay.io/biocontainers/duplex-tools:0.2.17--pyh7cba7a3_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        val(sample_id)
        path(summary_file)

    output:
        path("pair_ids.txt")

    script:
        """
        duplex_tools pairs_from_summary ${summary_file} ./
        """
}
