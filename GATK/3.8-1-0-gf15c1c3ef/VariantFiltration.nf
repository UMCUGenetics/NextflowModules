process VariantFiltrationSnpIndel {
    tag {"GATK VariantFiltrationSnpIndel ${analysis_id}"}
    label 'GATK_3_8_1_0_gf15c1c3ef'
    label 'GATK_3_8_1_0_gf15c1c3ef_VariantFiltrationSnpIndel'
    container = 'quay.io/biocontainers/gatk:3.8--py27_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(analysis_id, path(vcf_file), path(vcf_idx_file))

    output:
        tuple(analysis_id, path("${vcf_file.baseName}.filter.vcf"), path("${vcf_file.baseName}.filter.vcf.idx"), emit: vcf_file)

    script:
        """
        java -Xmx${task.memory.toGiga()-4}G -jar ${params.gatk_path} -T SelectVariants --reference_sequence ${params.genome} -V $vcf_file --out ${vcf_file.baseName}.snp.vcf --selectTypeToExclude INDEL
        java -Xmx${task.memory.toGiga()-4}G -jar ${params.gatk_path} -T SelectVariants --reference_sequence ${params.genome} -V $vcf_file --out ${vcf_file.baseName}.indel.vcf --selectTypeToInclude INDEL

        java -Xmx${task.memory.toGiga()-4}G -jar ${params.gatk_path} -T VariantFiltration --reference_sequence ${params.genome} -V ${vcf_file.baseName}.snp.vcf --out ${vcf_file.baseName}.snp_filter.vcf ${params.snp_filter} ${params.snp_cluster}
        java -Xmx${task.memory.toGiga()-4}G -jar ${params.gatk_path} -T VariantFiltration --reference_sequence ${params.genome} -V ${vcf_file.baseName}.indel.vcf --out ${vcf_file.baseName}.indel_filter.vcf ${params.indel_filter}

        java -Xmx${task.memory.toGiga()-4}G -jar ${params.gatk_path} -T CombineVariants --reference_sequence ${params.genome} -V ${vcf_file.baseName}.snp_filter.vcf -V ${vcf_file.baseName}.indel_filter.vcf --out ${vcf_file.baseName}.filter.vcf --assumeIdenticalSamples
        """
}
