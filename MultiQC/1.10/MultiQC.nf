process MultiQC {
    tag {"MultiQC"}
    label 'MultiQC_1_10'
    container = 'quay.io/biocontainers/multiqc:1.10--py_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        val(analysis_id)
        path(qc_files)

    output:
        tuple(path("${analysis_id}_multiqc_report.html"), path("${analysis_id}_multiqc_report_data"), emit: report)

    script:
        """
        multiqc ${params.optional} --title ${analysis_id} .
        """
}
