process Freec {
    tag {"Control_FREEC ${sample_id}"}
    label 'Control_FREEC_11_6'
    container = 'quay.io/biocontainers/control-freec:11.6--he1b5a44_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(bam_file), path(bai_file))

    output:
        tuple(sample_id, path("*"))

    script:
        """
        freec -conf ${params.config} -sample ${bam_file}
        """
}
