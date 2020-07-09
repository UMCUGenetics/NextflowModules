process FeatureCounts {
    tag {"Subread FeatureCounts ${run_id}"}
    label 'Subread_2_0_0'
    label 'Subread_2_0_0_FeatureCounts'
    container = 'quay.io/biocontainers/subread:2.0.0--hed695b0_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        val(run_id)
        path(bam_file)
        path(genome_gtf)   
  
    output:
        path("${run_id}_${params.fc_count_type}_featureCounts.raw.txt", emit: count_table)
        path("${run_id}_${params.fc_count_type}_featureCounts.txt.summary", emit: count_summary)
        path("${run_id}_biotype_featureCounts.matrix.txt", emit: biotype_count_table, optional: true)
        path("${run_id}_biotype_featureCounts.txt.summary", emit: biotype_count_summary, optional: true)

    script:
        //Adapted code from: https://github.com/nf-core/rnaseq - MIT License - Copyright (c) Phil Ewels, Rickard Hammarén
        def bam_list = bam_file.collect{ "$it" }.join(" ")
        def biotype = params.gencode ? "gene_type" : params.fc_group_features_type
        def extraAttributes = params.fc_extra_attributes ? "--extraAttributes ${params.fc_extra_attributes}" : ''
        //Get strandedness
        def featureCounts_direction = 0
        if (params.stranded && !params.unstranded) {
            featureCounts_direction = 1
        } else if (params.revstranded && !params.unstranded) {
            featureCounts_direction = 2
        }  
        //optional biotype QC
        def biotype_qc = params.biotypeQC ? "featureCounts -a ${genome_gtf} -g ${biotype} -o ${run_id}_biotype_featureCounts.txt -s ${featureCounts_direction} ${params.optional} ${bam_file}": ''
        def mod_biotype = params.biotypeQC ? "cut -f 1,7 ${run_id}_biotype_featureCounts.txt | tail -n +2 | sed 's/\\_Aligned.sortedByCoord.out.bam\\>//g'  > ${run_id}_biotype_featureCounts.matrix.txt": ''
        """
        featureCounts -T ${task.cpus} -a ${genome_gtf} -t ${params.fc_count_type} -g ${params.fc_group_features} -o ${run_id}_${params.fc_count_type}_featureCounts.txt -s ${featureCounts_direction} ${params.optional} ${extraAttributes} ${bam_list}   
        tail -n +2 ${run_id}_${params.fc_count_type}_featureCounts.txt | sed 's/\\_Aligned.sortedByCoord.out.bam\\>//g' > "${run_id}_${params.fc_count_type}_featureCounts.raw.txt"
        ${biotype_qc}
        ${mod_biotype}
        """
}
