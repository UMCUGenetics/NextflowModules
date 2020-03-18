process CombineVariants {
    tag {"GATK CombineVariants ${analysis_id}"}
    label 'GATK_3_8_1_0_gf15c1c3ef'
    label 'GATK_3_8_1_0_gf15c1c3ef_CombineVariants'
    container = 'quay.io/biocontainers/gatk:3.8--py27_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple val(analysis_id), file(vcf_files), file(vcf_idx_files)

    output:
    tuple val(analysis_id), file("${analysis_id}.vcf"), file("${analysis_id}.vcf.idx")

    script:
    def input_files = vcf_files.collect{"$it"}.join(" -V ")
    """
    java -Xmx${task.memory.toGiga()-4}G -jar ${params.gatk_path} -T CombineVariants --reference_sequence ${params.genome} -V ${input_files} --out ${analysis_id}.vcf ${params.optional}
    """
}
