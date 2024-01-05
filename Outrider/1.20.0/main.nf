
process OUTRIDER {
    tag "$meta.id"
    label 'process_medium'

    conda "${moduleDir}/environment.yml"
/*    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/fastqc:0.12.1--hdfd78af_0' :
        'biocontainers/fastqc:0.12.1--hdfd78af_0' }"*/

    input:
    tuple val(meta), path(counts)

    output:
    tuple val(meta), path("*.tsv"), emit: tsv
//    path  "versions.yml"           , emit: versions

 /*   when:
    task.ext.when == null || task.ext.when*/

    script:
    """
    printf "%s %s\\n" $rename_to | while read old_name new_name; do
        [ -f "\${new_name}" ] || ln -s \$old_name \$new_name
    done
    """

}