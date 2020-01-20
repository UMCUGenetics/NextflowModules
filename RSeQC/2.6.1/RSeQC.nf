
process RSeQC {
    tag {"RSeQC ${sample_id}"}
    label 'RSeQC_2_6_1'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.rseqc_mem}" : ""
    container = '/hpc/cog_bioinf/ubec/tools/rnaseq_containers/rseqc_2.6.1-squashfs-pack.gz.squashfs'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, file(sam_file), file(sam_index)
    file(bed_genome)

    output:
    tuple sample_id, file("*.{txt,pdf,r,xls}")

    script:
    """
    infer_experiment.py -i $sam_file -r $bed_genome > ${sample_id}.infer_experiment.txt
    junction_annotation.py -i $sam_file -o ${sample_id}.rseqc -r $bed_genome
    bam_stat.py -i $sam_file 2> ${sam_file.baseName}.bam_stat.txt
    junction_saturation.py -i $sam_file -o ${sam_file.baseName}.rseqc -r $bed_genome 2> ${sam_file.baseName}.junction_annotation_log.txt
    inner_distance.py -i $sam_file -o ${sam_file.baseName}.rseqc -r $bed_genome
    read_distribution.py -i $sam_file -r $bed_genome > ${sam_file.baseName}.read_distribution.txt
    read_duplication.py -i $sam_file -o ${sam_file.baseName}.read_duplication
    """
}
