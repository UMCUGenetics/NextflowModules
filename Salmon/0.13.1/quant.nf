process Quant {
    tag {"Quant ${sample_id}"}
    label 'Salmon_0_13_1'
    label 'Salmon_0_13_1_quant'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.salmon_mem}" : ""
    container = "/hpc/local/CentOS7/cog_bioinf/nextflow_containers/Salmon/0.13.1/salmon-0.13.1-squashfs-pack.gz.squashfs"
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, file(fastqs)
    file(salmon_index)
    file(genome_gtf)
   
    output:
    tuple sample_id, file("${sample_id}_salmon/") 

    shell:
    //Adapted code from: https://github.com/nf-core/rnaseq - MIT License - Copyright (c) Phil Ewels, Rickard Hammarén
    def rnastrandness = params.singleEnd ? 'U' : 'IU'
    if (strandness == "yes") {
       rnastrandness = params.singleEnd ? 'SF' : 'ISF'
    } else if (strandness == "reverse") {
       rnastrandness = params.singleEnd ? 'SR' : 'ISR'
    }
    def endedness = params.singleEnd ? "-r ${fastqs[0]}" : "-1 ${fastqs[0]} -2 ${fastqs[1]}"
    unmapped = params.saveUnaligned ? "--writeUnmappedNames" : ''
    """
    salmon quant --validateMappings \\
                   --seqBias --useVBOpt --gcBias \\
                   --geneMap ${genome_gtf} \\
                   --threads ${task.cpus} \\
                   --libType=${rnastrandness} \\
                   --index ${salmon_index} \\
                   $endedness $unmapped \\
                   -o ${sample_id}
    """
}

