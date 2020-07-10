process Command {
    tag {"Tool Command ${sample_id}"}
    label 'Tool_version'
    label 'Tool_verion_Command'
    container = 'container_url'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        val(analysis_id)
        tuple(sample_id, path(input_file))
     
    output:
        tuple(sample_id, path(output_file), emit: output_file)
        path("log.txt", emit: log)

    script:
        """
        tool command ${params.optional} ${analysis_id} ${params.resource_file} ${input_file} 
        """
}
