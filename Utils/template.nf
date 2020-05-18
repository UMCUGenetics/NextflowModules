process Command {
    tag {"Tool Command ${sample_id}"}
    label 'Tool_version'
    label 'Tool_verion_Command'
    container = 'container_url'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(input_file))
     
    output:
        tuple(sample_id, path(output_file), emit: output_file)
    
    script:
        """
        tool command ${params.optional}
        """

}
