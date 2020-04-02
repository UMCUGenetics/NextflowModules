
process RSeQC {
    tag {"RSeQC ${sample_id}"}
    label 'RSeQC_3_0_1'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = "quay.io/biocontainers/rseqc:3.0.1--py37h516909a_1"
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, file(bam), file(bai)
    file(genome_bed12)

    output:
    tuple sample_id, file("*.{txt,pdf,r,xls}")

    script:
    //Adapted code from: https://github.com/nf-core/rnaseq - MIT License - Copyright (c) Phil Ewels, Rickard Hammarén
    """
    inner_distance.py -i ${bam} -o ${bam.baseName}.rseqc -r ${genome_bed12}
    read_distribution.py -i ${bam} -r ${genome_bed12} > ${bam.baseName}.read_distribution.txt
    infer_experiment.py -i ${bam} -r ${genome_bed12} > ${bam.baseName}.infer_experiment.txt
    junction_annotation.py -i ${bam} -o ${bam.baseName}.rseqc -r ${genome_bed12}
    bam_stat.py -i ${bam} 2> ${bam.baseName}.bam_stat.txt
    junction_saturation.py -i ${bam} -o ${bam.baseName}.rseqc -r ${genome_bed12} 2> ${bam.baseName}.junction_annotation_log.txt
    read_duplication.py -i ${bam} -o ${bam.baseName}.read_duplication
    """
}
