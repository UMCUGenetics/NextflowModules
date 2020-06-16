process AssessSignificance {
    tag {"Control Freec AssessSignificance ${sample_id}"}
    label 'ControlFreec_11_5'
    label 'ControlFreec_11_5_AssessSignificance'
    container = 'quay.io/biocontainers/control-freec:11.5--he1b5a44_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(ratio_file), path(cnv_file))

    output:
        tuple(sample_id, path("${cnv_file.name}.p.value.txt"), emit: cnv_pvalue)

    script:
        """
        cat /usr/local/bin/assess_significance.R | R --slave --args ${cnv_file} ${ratio_file}
        """
}
