
process OUTRIDER {
    tag "$meta.id"
    label 'process_medium'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/bioconductor-outrider:1.20.0--r43hf17093f_0 ' :
        'biocontainers/bioconductor-outrider:1.20.0--r43hf17093f_0 ' }"

    input:
    tuple val(meta), path(counts), path(ref)

    output:
    tuple val(meta), path("*.tsv"), emit: tsv
//    path  "versions.yml"           , emit: versions

 /*   when:
    task.ext.when == null || task.ext.when*/

    script:
    """
    echo $counts
    echo $ref
    Rscript "outrider.R" "$counts" "/out" -r "$ref" 
    """

}