process Quant {
    tag {"Salmon Quant ${sample_id}"}
    label 'Salmon_1_2_1'
    label 'Salmon_1_2_1_Quant'
    container = 'quay.io/biocontainers/salmon:1.2.1--hf69c8f4_0'
    shell = ['/bin/bash', '-euo', 'pipefail']
    
    input:
        tuple(sample_id, path(fastq_files))
        path(salmon_index)
   
    output:
        tuple(sample_id, path("${sample_id}/"), emit: quant_table)

    script:
        //Adapted code from: https://github.com/nf-core/rnaseq - MIT License - Copyright (c) Phil Ewels, Rickard Hammarén
        def rnastrandness = params.singleEnd ? 'U' : 'IU'
        if (params.stranded && !params.unstranded) {
            rnastrandness = params.singleEnd ? 'SF' : 'ISF'
        } else if (params.revstranded && !params.unstranded) {
            rnastrandness = params.singleEnd ? 'SR' : 'ISR'
        }
        def endedness = params.singleEnd ? "-r ${fastq_files[0]}" : "-1 ${fastq_files[0]} -2 ${fastq_files[1]}"
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

