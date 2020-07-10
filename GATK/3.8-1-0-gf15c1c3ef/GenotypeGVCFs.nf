process GenotypeGVCFs {
    tag {"GATK GenotypeGVCFs ${analysis_id}"}
    label 'GATK_3_8_1_0_gf15c1c3ef'
    label 'GATK_3_8_1_0_gf15c1c3ef_GenotypeGVCFs'
    container = 'quay.io/biocontainers/gatk:3.8--py27_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(analysis_id, path(gvcf_files), path(gvcf_idx_files), path(interval_file))

    output:
        tuple(analysis_id, path("${analysis_id}_${interval_file.baseName}.vcf"), path("${analysis_id}_${interval_file.baseName}.vcf.idx"), emit:vcf_file)

    script:
        def input_files = gvcf_files.collect{"$it"}.join(" -V ")
        """
        java -Xmx${task.memory.toGiga()-4}G -jar ${params.gatk_path} -T GenotypeGVCFs \
        --reference_sequence ${params.genome} \
        -V ${input_files} \
        --out ${analysis_id}_${interval_file.baseName}.vcf \
        --intervals ${interval_file} \
        ${params.optional} \
        """
}
