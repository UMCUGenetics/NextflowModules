process Quant {
    tag {"Salmon Quant ${sample_id}"}
    label 'Salmon_1_9_0'
    label 'Salmon_1_9_0_Quant'
    container = 'quay.io/biocontainers/salmon:1.9.0--h7e5ed60_1'
    shell = ['/bin/bash', '-euo', 'pipefail']
    
    input:
        tuple(val(sample_id), path(fastq_files))
        path(salmon_index)
   
    output:
        tuple(val(sample_id), path("${sample_id}/"), emit: quant_table)

    script:
        //Adapted code from: https://github.com/nf-core/rnaseq - MIT License - Copyright (c) Phil Ewels, Rickard Hammarén
        def rnastrandness = params.single_end ? 'U' : 'IU'
        if (params.stranded && !params.unstranded) {
            rnastrandness = params.single_end ? 'SF' : 'ISF'
        } else if (params.revstranded && !params.unstranded) {
            rnastrandness = params.single_end ? 'SR' : 'ISR'
        }
        def endedness = params.single_end ? "-r ${fastq_files[0]}" : "-1 ${fastq_files[0]} -2 ${fastq_files[1]}"
        def unmapped = params.saveUnaligned ? "--writeUnmappedNames" : ''

        """
        salmon quant --validateMappings \
                    ${params.optional} \
                    --threads ${task.cpus} \
                    --libType=${rnastrandness} \
                    --index ${salmon_index} \
                    ${endedness} ${unmapped} \
                    -o ${sample_id}              
        """
}

