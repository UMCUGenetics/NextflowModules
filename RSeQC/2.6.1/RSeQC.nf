
process RSeQC {
    tag {"RSeQC - ${sample_id}"}
    label 'RSeQC_2_6_1'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.rseqc_mem}" : ""
    container = '/hpc/cog_bioinf/ubec/tools/rnaseq_containers/rseqc_2.6.1_R_3.6.1-squashfs-pack.gz.squashfs'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, file(bam_rseqc), file(bam_index_rseqc)
    file(bed12)

    output:
    tuple sample_id, file("*.{txt,pdf,r,xls}")

    script:
    def inner_distance_arg = !params.singleEnd ? "inner_distance.py -i $bam_rseqc -o ${bam_rseqc.baseName}.rseqc -r $bed12" :''
    def read_distribution_arg = !params.singleEnd ? "read_distribution.py -i $bam_rseqc -r $bed12 > ${bam_rseqc.baseName}.read_distribution.txt" :''
    """
    infer_experiment.py -i $bam_rseqc -r $bed12 > ${bam_rseqc.baseName}.infer_experiment.txt
    junction_annotation.py -i $bam_rseqc -o ${bam_rseqc.baseName}.rseqc -r $bed12
    bam_stat.py -i $bam_rseqc 2> ${bam_rseqc.baseName}.bam_stat.txt
    junction_saturation.py -i $bam_rseqc -o ${bam_rseqc.baseName}.rseqc -r $bed12 2> ${bam_rseqc.baseName}.junction_annotation_log.txt
    read_duplication.py -i $bam_rseqc -o ${bam_rseqc.baseName}.read_duplication
    $inner_distance_arg
    $read_distribution_arg
    """
}
