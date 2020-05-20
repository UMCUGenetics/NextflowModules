process IndelRealigner {
    tag {"GATK IndelRealigner ${sample_id} - ${chr}"}
    label 'GATK_3_8_1_0_gf15c1c3ef'
    label 'GATK_3_8_1_0_gf15c1c3ef_IndelRealigner'
    container = 'quay.io/biocontainers/gatk:3.8--py27_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(bam_file), path(bai_file), chr, path(target_intervals))

    output:
        tuple(sample_id, path("${bam_file.baseName}.realigned.${chr}.bam"), path("${bam_file.baseName}.realigned.${chr}.bai"), emit: bam_file)

    script:
        """
        java -Xmx${task.memory.toGiga()-4}G -jar ${params.gatk_path} -T IndelRealigner \
        --reference_sequence ${params.genome} \
        --input_file ${bam_file} \
        --intervals ${chr} \
        --targetIntervals ${bam_file.baseName}.target_intervals.${chr}.list \
        --out ${bam_file.baseName}.realigned.${chr}.bam \
        ${params.optional}
        """
}
