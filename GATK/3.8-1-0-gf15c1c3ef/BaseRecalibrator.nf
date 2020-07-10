process BaseRecalibrator {
    tag {"GATK BaseRecalibrator ${sample_id} - ${chr}"}
    label 'GATK_3_8_1_0_gf15c1c3ef'
    label 'GATK_3_8_1_0_gf15c1c3ef_BaseRecalibrator'
    container = 'quay.io/biocontainers/gatk:3.8--py27_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(bam_file), path(bai_file), chr)

    output:
        tuple(sample_id, path("${bam_file.baseName}.bqsr.${chr}.bam"), path("${bam_file.baseName}.bqsr.${chr}.bai"), emit: bam_file)

    script:
        """
        java -Xmx${task.memory.toGiga()-4}G -jar $params.gatk_path -T BaseRecalibrator \
        --num_cpu_threads_per_data_thread ${task.cpus} \
        --reference_sequence ${params.genome} \
        --input_file ${bam_file} \
        --intervals ${chr} \
        --out ${bam_file.baseName}.bqsr.${chr}.table \
        ${params.optional_bqsr}

        java -Xmx${task.memory.toGiga()-4}G -jar ${params.gatk_path} -T PrintReads \
        --num_cpu_threads_per_data_thread ${task.cpus} \
        --reference_sequence ${params.genome} \
        --input_file ${bam_file} \
        --BQSR ${bam_file.baseName}.bqsr.${chr}.table \
        --intervals ${chr} \
        --out ${bam_file.baseName}.bqsr.${chr}.bam \
        ${params.optional_pr}
        """
}
