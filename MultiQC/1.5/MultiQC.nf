
process MultiQC {
    tag {"MultiQC ${id}"}
    publishDir "$params.out_dir/MultiQC", mode: 'copy'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.multiqc_mem}" : ""

    input:
    val id

    output:
    file("${id}.html")


    script:
    """
    multiqc $params.out_dir -n ${id}.html --interactive
    """
}
