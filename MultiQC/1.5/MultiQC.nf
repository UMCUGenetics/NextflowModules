
process MultiQC {
    tag {"MULTIQC ${id}"}
    label 'MULTIQC_1_5'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.multiqc.mem}" : ""

    input:
    val id

    output:
    file("${id}.html")


    script:
    """
    
    multiqc $params.out_dir -n ${id}.html ${params.multiqc.toolOptions}
    """
}
