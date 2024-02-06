process OUTRIDER {
    tag "$meta.id"
    label 'process_medium'

    conda "${moduleDir}/environment.yml"
    container "ghcr.io/umcugenetics/outrider_custom:0.0.1"

    input:
    tuple val(meta), path(counts)
    path(ref)
    val(feature)

    output:
    path("*.tsv"), emit: tsv
//    path  "versions.yml"           , emit: versions

 /*   when:
    task.ext.when == null || task.ext.when*/

    script:
    """
    echo "${meta}"
    echo "${ref}"
    echo "${counts}"
    Rscript ${moduleDir}/outrider.R ${counts} -r ${ref} -f ${feature}
    """

}