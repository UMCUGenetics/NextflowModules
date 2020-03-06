process IndelRealigner {
    tag {"GATK IndelRealigner ${sample_id} - ${rg_id}"}
    label 'GATK_3_8_1_0_gf15c1c3ef'
    label 'GATK_3_8_1_0_gf15c1c3ef_IndelRealigner'
    container = 'quay.io/biocontainers/gatk:3.8--py27_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple val(sample_id), file(bam_file), file(bai_file)

    output:
    tuple val(sample_id), file("${bam_file.baseName}.realigned.bam"), file("${bam_file.baseName}.realigned.bam.bai")

    script:

    """
    java -Xmx${task.memory.toGiga()-4}G -jar $params.gatk_path -T RealignerTargetCreator \
    --reference_sequence $params.genome \
    --input_file $bam_file \
    --out ${bam_file.baseName}.target_intervals.list \
    $params.optional

    java -Xmx${task.memory.toGiga()-4}G -jar $params.gatk_path -T IndelRealigner \
    --reference_sequence $params.genome \
    --input_file $bam_file \
    --targetIntervals ${bam_file.baseName}.target_intervals.list \
    --out ${bam_file.baseName}.realigned.bam \
    $params.optional
    """
}
