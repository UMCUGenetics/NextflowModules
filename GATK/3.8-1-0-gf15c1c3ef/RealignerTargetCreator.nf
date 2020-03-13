process RealignerTargetCreator {
    tag {"GATK RealignerTargetCreator ${sample_id} - ${chr}"}
    label 'GATK_3_8_1_0_gf15c1c3ef'
    label 'GATK_3_8_1_0_gf15c1c3ef_RealignerTargetCreator'
    container = 'quay.io/biocontainers/gatk:3.8--py27_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple val(sample_id), file(bam_file), file(bai_file), val(chr)

    output:
    tuple val(sample_id), val(chr), file("${bam_file.baseName}.target_intervals.${chr}.list")

    script:

    """
    java -Xmx${task.memory.toGiga()-4}G -jar $params.gatk_path -T RealignerTargetCreator \
    --reference_sequence $params.genome \
    --input_file $bam_file \
    --intervals $chr \
    --out ${bam_file.baseName}.target_intervals.${chr}.list \
    $params.optional
    """
}