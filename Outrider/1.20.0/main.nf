process OUTRIDER {
    tag "$meta.id"
    label 'process_high'

    conda "${moduleDir}/environment.yml"
    container "ghcr.io/umcugenetics/outrider_custom:0.0.1"

    input:
    tuple val(meta), path(counts), val(feature)
    path(ref_gene)
    path(ref_exon)

    output:
    path("*.tsv"), emit: tsv
    //path  "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def refset = ref_gene
    if (feature == 'exon') {
        refset = ref_exon
    }
    """
    echo "${meta}"
    echo "${counts}"
    echo "${refset}"
    Rscript ${moduleDir}/outrider.R ${counts} -r ${refset} -f ${feature}
    """
}