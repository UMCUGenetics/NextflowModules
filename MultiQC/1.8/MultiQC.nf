params.multiqc.optional

process MultiQC {
    tag {"MultiQC"}
    label 'MultiQC_1_8'
    container = 'quay.io/biocontainers/multiqc:1.8--py_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    file(qc_files: "*")

    output:
    file "multiqc_report.html"
    file "multiqc_data"

    script:
    """
    multiqc ${params.fastqc.optional} .
    """
}
