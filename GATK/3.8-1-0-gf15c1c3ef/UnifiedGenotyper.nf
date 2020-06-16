process UnifiedGenotyper {
    tag {"GATK UnifiedGenotyper ${sample_id}"}
    label 'GATK_3_8_1_0_gf15c1c3ef'
    label 'GATK_3_8_1_0_gf15c1c3ef_UnifiedGenotyper'
    container = 'quay.io/biocontainers/gatk:3.8--py27_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(bam_file), path(bai_file))

    output:
        tuple(sample_id, path("${sample_id}.vcf"), emit: vcf_file)

    script:

        """
        java -Xmx${task.memory.toGiga()-4}G -jar ${params.gatk_path} -T UnifiedGenotyper --reference_sequence ${params.genome} --input_file ${bam_file} --out ${sample_id}.vcf ${params.optional}
        """
}
