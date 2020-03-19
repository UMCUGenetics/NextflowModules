process Quant {
    tag {"Salmon Quant ${sample_id}"}
    label 'Salmon_0_13_1'
    label 'Salmon_0_13_1_Quant'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.salmon_mem}" : ""
    container = "/hpc/local/CentOS7/cog_bioinf/nextflow_containers/Salmon/0.13.1/salmon-0.13.1-squashfs-pack.gz.squashfs"
    shell = ['/bin/bash', '-euo', 'pipefail']
    
    input:
    tuple sample_id, file(fastqs)
    file(salmon_index)
    
   
    output:
    tuple sample_id, file("${sample_id}/")

    shell:
    //Adapted code from: https://github.com/nf-core/rnaseq - MIT License - Copyright (c) Phil Ewels, Rickard Hammarén
    def rnastrandness = params.singleEnd ? 'U' : 'IU'
    if (params.stranded && !params.unstranded) {
       rnastrandness = params.singleEnd ? 'SF' : 'ISF'
    } else if (params.revstranded && !params.unstranded) {
       rnastrandness = params.singleEnd ? 'SR' : 'ISR'
    }
    def endedness = params.singleEnd ? "-r ${fastqs[0]}" : "-1 ${fastqs[0]} -2 ${fastqs[1]}"
    unmapped = params.saveUnaligned ? "--writeUnmappedNames" : ''
    """
    salmon quant --validateMappings \\
                   --seqBias --useVBOpt --gcBias \\
                   --threads ${task.cpus} \\
                   --libType=${rnastrandness} \\
                   --index ${salmon_index} \\
                   $endedness $unmapped \\
                  -o ${sample_id}              
    """
}

