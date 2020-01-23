
process RSeQC {
    tag {"RSeQC ${sample_id}"}
    label 'RSeQC_2_6_1'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.rseqc_mem}" : ""
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, file(bams), file(bais)
    file(genome_bed12)

    output:
    tuple sample_id, file("*.{txt,pdf,r,xls}")

    script:
    //Adapted code from: https://github.com/nf-core/rnaseq - MIT License - Copyright (c) Phil Ewels, Rickard Hammarén
    def inner_distance_arg = !params.singleEnd ? "inner_distance.py -i $bams -o ${bams.baseName}.rseqc -r $genome_bed12" :''
    def read_distribution_arg = !params.singleEnd ? "read_distribution.py -i $bams -r $genome_bed12 > ${bams.baseName}.read_distribution.txt" :''
    """
    infer_experiment.py -i $bams -r $genome_bed12 > ${bams.baseName}.infer_experiment.txt
    junction_annotation.py -i $bams -o ${bams.baseName}.rseqc -r $genome_bed12
    bam_stat.py -i $bams 2> ${bams.baseName}.bam_stat.txt
    junction_saturation.py -i $bams -o ${bams.baseName}.rseqc -r $genome_bed12 2> ${bams.baseName}.junction_annotation_log.txt
    read_duplication.py -i $bams -o ${bams.baseName}.read_duplication
    $inner_distance_arg
    $read_distribution_arg
    """
}