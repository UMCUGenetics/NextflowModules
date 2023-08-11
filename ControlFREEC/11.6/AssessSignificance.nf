process AssessSignificance {
    tag {"Control Freec AssessSignificance ${sample_id}"}
    label 'ControlFreec_11_6'
    label 'ControlFreec_11_6_AssessSignificance'
    container = 'quay.io/biocontainers/control-freec:11.6--h87f3376_2'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(ratio_file), path(cnv_file))

    output:
        tuple(val(sample_id), path("${cnv_file.name}.p.value.txt"), emit: cnv_pvalue)

    script:
        """
        cat /usr/local/bin/assess_significance.R | R --slave --args ${cnv_file} ${ratio_file}
        """
}
