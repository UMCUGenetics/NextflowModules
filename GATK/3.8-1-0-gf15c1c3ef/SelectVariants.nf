process SelectVariantsSample {
    tag {"GATK SelectVariantsSample ${analysis_id} - ${sample_id}"}
    label 'GATK_3_8_1_0_gf15c1c3ef'
    label 'GATK_3_8_1_0_gf15c1c3ef_SelectVariantsSample'
    container = 'quay.io/biocontainers/gatk:3.8--py27_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(analysis_id, path(vcf_file), path(vcf_idx_file), sample_id)

    output:
        tuple(sample_id, path("${sample_id}_${vcf_file.baseName}.vcf"), path("${sample_id}_${vcf_file.baseName}.vcf.idx"), emit: vcf_file)

    script:
        """
        java -Xmx${task.memory.toGiga()-4}G -jar ${params.gatk_path} -T SelectVariants --reference_sequence ${params.genome} -V ${vcf_file} --out ${sample_id}_${vcf_file.baseName}.vcf -sn ${sample_id}
        """
}
