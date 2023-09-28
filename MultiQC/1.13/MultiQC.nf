process MultiQC {
    tag {"MultiQC"}
    label 'MultiQC_1_13'
    container = 'quay.io/biocontainers/multiqc:1.13--pyhdfd78af_0'
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
