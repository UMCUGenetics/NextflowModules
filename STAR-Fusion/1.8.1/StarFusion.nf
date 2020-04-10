process StarFusion {
    tag {"StarFusion ${sample_id}"}
    label 'StarFusion_1_8_1'
    container = 'quay.io/biocontainers/star-fusion:1.8.1--2'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, file(fastqs)
    file(reference)
    file(chim_junctions)

    output:
    tuple sample_id, file("*fusion_predictions.tsv"), file("*.{tsv,txt}")


    script:
    def read_args = params.singleEnd ? "--left_fq ${fastqs[0]}" : "--left_fq ${fastqs[0]} --right_fq ${fastqs[1]}"
    
    """
    STAR-Fusion \
        --genome_lib_dir ${reference} \
        -J ${chim_junctions} \
        ${read_args} \
        --CPU ${task.cpus} \
        --examine_coding_effect \
        --output_dir .
    """

}
