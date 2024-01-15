process OUTRIDER {
//    tag "$meta.id"
    label 'process_medium'

    conda "${moduleDir}/environment.yml"
    container "ghcr.io/umcugenetics/outrider_custom:0.0.1"

    input:
    path(counts)
    path(ref)
    
    output:
    path("*.tsv"), emit: tsv
//    path  "versions.yml"           , emit: versions

 /*   when:
    task.ext.when == null || task.ext.when*/

    script:
    """
    Rscript "${moduleDir}/outrider.R" "${counts}" -r "${ref}"
    """

//    mkdir -p ${params.outdir}/outrider
//   Rscript "/hpc/diaggen/users/lonneke/github/DxNextflowRNA/NextflowModules/Outrider/1.20.0/outrider.R" "${counts}" -o "${params.outdir}/outrider/" -r "${ref}" 
}