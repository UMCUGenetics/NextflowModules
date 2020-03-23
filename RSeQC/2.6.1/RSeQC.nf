
process RSeQC {
    tag {"RSeQC ${sample_id}"}
    label 'RSeQC_2_6_1'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = "/hpc/local/CentOS7/cog_bioinf/nextflow_containers/RSeQC/rseqc_2.6.1_R_3.6.1-squashfs-pack.gz.squashfs"
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, file(bam), file(bai)
    file(genome_bed12)

    output:
    tuple sample_id, file("*.{txt,pdf,r,xls}")

    script:
    //Adapted code from: https://github.com/nf-core/rnaseq - MIT License - Copyright (c) Phil Ewels, Rickard Hammarén
    //def inner_distance_arg = !params.singleEnd ? "inner_distance.py -i $bam -o ${bam.baseName}.rseqc -r $genome_bed12" :''
    //def read_distribution_arg = !params.singleEnd ? "read_distribution.py -i $bam -r $genome_bed12 > ${bam.baseName}.read_distribution.txt" :''
    """
    inner_distance.py -i $bam -o ${bam.baseName}.rseqc -r $genome_bed12
    read_distribution.py -i $bam -r $genome_bed12 > ${bam.baseName}.read_distribution.txt
    infer_experiment.py -i $bam -r $genome_bed12 > ${bam.baseName}.infer_experiment.txt
    junction_annotation.py -i $bam -o ${bam.baseName}.rseqc -r $genome_bed12
    bam_stat.py -i $bam 2> ${bam.baseName}.bam_stat.txt
    junction_saturation.py -i $bam -o ${bam.baseName}.rseqc -r $genome_bed12 2> ${bam.baseName}.junction_annotation_log.txt
    read_duplication.py -i $bam -o ${bam.baseName}.read_duplication
    """
}
