
process MultiQC {
    tag {"MultiQC"}
    label 'MultiQC_1_5'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:multiqc-1.5'
    shell = ['/bin/bash', '-euo', 'pipefail']
    input:
        path("*")

    output:
        path ("multiqc_report.html", emit : multiqc_report)
        path ("multiqc_data", emit : multiqc_data)

    script:
        """
        multiqc ${params.optional} .
        """
}
