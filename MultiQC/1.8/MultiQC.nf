process MultiQC {
    tag {"MultiQC"}
    label 'MultiQC_1_8'
    container = 'quay.io/biocontainers/multiqc:1.8--py_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple val(analysis_id), file(qc_files: "*")

    output:
    file "${analysis_id}_multiqc_report.html"
    file "${analysis_id}_multiqc_data"

    script:
    """
    multiqc ${params.optional} --title ${analysis_id} .
    """
}
