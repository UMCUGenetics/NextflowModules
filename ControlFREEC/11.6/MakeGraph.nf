process MakeGraph {
    tag {"Control Freec MakeGraph ${sample_id}"}
    label 'ControlFreec_11_6'
    label 'ControlFreec_11_6_MakeGraph'
    container = 'quay.io/biocontainers/control-freec:11.6--h87f3376_2'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(ratio_file), path(cnv_file))

    output:
        tuple(val(sample_id), path("${ratio_file.name}.png"), path("${ratio_file.name}.log2.png"), emit: ratio_png)

    script:
        """
        cat /usr/local/bin/makeGraph.R | R --slave --args ${params.ploidy} ${ratio_file}
        """
}
