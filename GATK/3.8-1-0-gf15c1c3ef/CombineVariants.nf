process CombineVariants {
    tag {"GATK CombineVariants ${analysis_id}"}
    label 'GATK_3_8_1_0_gf15c1c3ef'
    label 'GATK_3_8_1_0_gf15c1c3ef_CombineVariants'
    container = 'quay.io/biocontainers/gatk:3.8--py27_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(analysis_id, path(vcf_files), path(vcf_idx_files))

    output:
        tuple(analysis_id, path("${analysis_id}.vcf"), path("${analysis_id}.vcf.idx"), emit:vcf_file)

    script:
        def input_files = vcf_files.collect{"$it"}.join(" -V ")
        """
        java -Xmx${task.memory.toGiga()-4}G -jar ${params.gatk_path} -T CombineVariants --reference_sequence ${params.genome} -V ${input_files} --out ${analysis_id}.vcf ${params.optional}
        """
}

process CombineVariantsGVCF {
    tag {"GATK CombineVariantsGVCF ${sample_id}"}
    label 'GATK_3_8_1_0_gf15c1c3ef'
    label 'GATK_3_8_1_0_gf15c1c3ef_CombineVariantsGVCF'
    container = 'quay.io/biocontainers/gatk:3.8--py27_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(vcf_files), path(vcf_idx_files))

    output:
        tuple(sample_id, path("${sample_id}.g.vcf"), path("${sample_id}.g.vcf.idx"), emit:vcf_file)

    script:
        def input_files = vcf_files.collect{"$it"}.join(" -V ")
        """
        java -Xmx${task.memory.toGiga()-4}G -jar ${params.gatk_path} -T CombineVariants --reference_sequence ${params.genome} -V ${input_files} --out ${sample_id}.g.vcf ${params.optional}
        """
}
