process featureCounts {
    tag {"subread featureCounts ${run_id}"}
    label 'subread_2_0_0'
    label 'subread_2_0_0_featureCounts'
    container = 'quay.io/biocontainers/subread:2.0.0--hed695b0_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    val run_id
    file(bam_file)
    file(genome_gtf)   
  
    output:
    tuple file("${run_id}_gene.featureCounts.txt"), file("${run_id}_gene.featureCounts.txt.summary")

    shell:
    //Adapted code from: https://github.com/nf-core/rnaseq - MIT License - Copyright (c) Phil Ewels, Rickard Hammarén
    def featureCounts_direction = 0
    if (params.stranded && !params.unstranded) {
          featureCounts_direction = 1
    } else if (params.revstranded && !params.unstranded) {
          featureCounts_direction = 2
    }     
    def bam_list = bam_file.collect{ "$it" }.join(" ")
    """
    featureCounts -a ${genome_gtf} -t ${params.fc_count_type} -g ${params.fc_group_features} -o ${run_id}_gene.featureCounts.txt -p -s ${featureCounts_direction} ${bam_list}
    """
}
