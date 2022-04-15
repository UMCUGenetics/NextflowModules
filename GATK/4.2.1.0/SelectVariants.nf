process SelectVariantsSample {
    tag {"GATK SelectVariantsSample ${analysis_id} - ${sample_id}"}
    label 'GATK_4_2_1_0'
    label 'GATK_4_2_1_0_SelectVariantsSample'
    container = 'broadinstitute/gatk:4.2.1.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(analysis_id, path(vcf_file), path(vcf_idx_file), sample_id)

    output:
        tuple(sample_id, path("${sample_id}_${vcf_file.baseName}${ext_vcf}"), path("${sample_id}_${vcf_file.baseName}${ext_vcf}${ext_vcf_index}"), emit: vcf_file)

    script:
        ext_vcf = params.compress || vcf_file.getExtension() == ".gz" ? ".vcf.gz" : ".vcf"
        ext_vcf_index = params.compress || vcf_file.getExtension() == ".gz" ? ".tbi" : ".idx"
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}G" SelectVariants \
        --reference ${params.genome} \
        --variant ${vcf_file} \
        --output ${sample_id}_${vcf_file.baseName}${ext_vcf} \
        --sample-name ${sample_id} \
        ${params.optional}
        """
}
