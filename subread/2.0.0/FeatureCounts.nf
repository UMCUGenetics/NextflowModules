process FeatureCounts {
    tag {"subread FeatureCounts ${run_id}"}
    label 'subread_2_0_0'
    label 'subread_2_0_0_FeatureCounts'
    container = 'quay.io/biocontainers/subread:2.0.0--hed695b0_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    val run_id
    file(bam_file)
    file(genome_gtf)   
  
    output:
    tuple file("${run_id}_${params.fc_count_type}_featureCounts.txt"), file("${run_id}_biotype_featureCounts.txt"), file("${run_id}_${params.fc_count_type}_featureCounts_matrix.txt"), file("${run_id}_biotype_featureCounts.txt.summary"), file("${run_id}_${params.fc_count_type}_featureCounts.txt.summary")

    script:
    //Adapted code from: https://github.com/nf-core/rnaseq - MIT License - Copyright (c) Phil Ewels, Rickard Hammarén

    def biotype = params.gencode ? "gene_type" : params.fc_group_features_type
    def extraAttributes = params.fc_extra_attributes ? "--extraAttributes ${params.fc_extra_attributes}" : ''
    def featureCounts_direction = 0
    if (params.stranded && !params.unstranded) {
          featureCounts_direction = 1
    } else if (params.revstranded && !params.unstranded) {
          featureCounts_direction = 2
    }     
    def bam_list = bam_file.collect{ "$it" }.join(" ")
    """
    featureCounts -T ${task.cpus} -a ${genome_gtf} -t ${params.fc_count_type} -g ${params.fc_group_features} -o ${run_id}_${params.fc_count_type}_featureCounts.txt ${extraAttributes} ${params.optional} -p -s ${featureCounts_direction} ${bam_list}
    featureCounts -T ${task.cpus} -a ${genome_gtf} -g ${biotype} -o ${run_id}_biotype_featureCounts.txt ${params.optional} -p -s ${featureCounts_direction} ${bam_list}   
    tail -n +2 ${run_id}_${params.fc_count_type}_featureCounts.txt | cut -f 1,7- | sed 's/\\_Aligned.sortedByCoord.out.bam\\>//g' >  "${run_id}_${params.fc_count_type}_featureCounts_matrix.txt"
    """
}
