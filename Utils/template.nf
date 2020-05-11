process Command {
    tag {"Tool Command ${sample_id}"}
    label 'Tool_version'
    label 'Tool_verion_Command'
    container = 'container_url'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    path input_file
     
    output:
    path output_file, emit: output_file
    


    script:
    """
    tool command ${params.optional}
    """

}
