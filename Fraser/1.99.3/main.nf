
process FRASER {
    tag "$meta.id"
    label 'process_high'

    conda "${moduleDir}/environment.yml"
    container "quay.io/biocontainers/bioconductor-fraser:1.99.3--r43hf17093f_0"

    input:
    tuple val(meta), path(input)
    path(refset)

    output:
    path("*.tsv"), emit: tsv
//    path  "versions.yml"           , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    export BIOMART_CACHE=/hpc/diaggen/projects/woc/rna/container
    Rscript ${moduleDir}/fraser.R ${input} ${refset} ${prefix} TRUE
    """
}
