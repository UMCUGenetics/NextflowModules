process OUTRIDER {
    tag "$meta.id"
    label 'process_high'

    conda "${moduleDir}/environment.yml"
    container "ghcr.io/umcugenetics/outrider_custom:0.0.1"

    input:
    tuple val(meta), path(counts)
    path(refset)

    output:
    path("*.tsv"), emit: tsv
//    path  "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    Rscript ${moduleDir}/outrider.R ${counts} -r ${refset} -p ${prefix}
    """
}