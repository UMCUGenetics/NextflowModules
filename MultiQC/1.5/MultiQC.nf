
process MultiQC {
    tag {"MULTIQC ${id}"}
    label 'MULTIQC_1_5'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.multiqc.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:multiqc-1.5'

    input:

    file(qc_files: "*")

    output:
    file "multiqc_report.html"
    file "multiqc_data"


    script:
    """

    multiqc ${params.multiqc.toolOptions} $params.out_dir 
    """
}
