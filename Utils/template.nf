params.tool.command.optional

process Command {
    tag {"Tool Command ${sample_id} - ${rg_id}"}
    label 'Tool_version'
    label 'Tool_verion_Command'
    container = 'container_url'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, file(input_file)

    output:
    tuple sample_id, file(output_file)


    script:
    """
    tool command $params.tool.command.optional
    """

}
