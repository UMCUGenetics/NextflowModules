process MakeGraph {
    tag {"Control Freec MakeGraph ${sample_id}"}
    label 'ControlFreec_11_5'
    label 'ControlFreec_11_5_MakeGraph'
    container = 'library://sawibo/default/bioinf-tools:freec11.5'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(ratio_file), path(cnv_file))

    output:
        tuple(sample_id, path("${ratio_file.name}.png"), path("${ratio_file.name}.log2.png"), emit: ratio_png)

    script:
        """
        cat /bin/makeGraph.R | R --slave --args ${params.ploidy} ${ratio_file}
        """
}
