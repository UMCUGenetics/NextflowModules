process SelectVariantsSample {
    tag {"GATK SelectVariantsSample ${analysis_id} - ${sample_id}"}
    label 'GATK_3_8_1_0_gf15c1c3ef'
    label 'GATK_3_8_1_0_gf15c1c3ef_SelectVariantsSample'
    container = 'quay.io/biocontainers/gatk:3.8--py27_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple val(analysis_id), file(vcf_file), file(vcf_idx_file), val(sample_id)

    output:
    tuple val(sample_id), file("${sample_id}_${vcf_file.baseName}.vcf"), file("${sample_id}_${vcf_file.baseName}.vcf.idx")

    script:
    """
    java -Xmx${task.memory.toGiga()-4}G -jar ${params.gatk_path} -T SelectVariants --reference_sequence ${params.genome} -V ${vcf_file} --out ${sample_id}_${vcf_file.baseName}.vcf -sn ${sample_id}
    """
}