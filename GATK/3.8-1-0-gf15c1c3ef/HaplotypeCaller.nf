process HaplotypeCaller {
    tag {"GATK HaplotypeCaller ${analysis_id} - ${interval_file.baseName}"}
    label 'GATK_3_8_1_0_gf15c1c3ef'
    label 'GATK_3_8_1_0_gf15c1c3ef_HaplotypeCaller'
    container = 'quay.io/biocontainers/gatk:3.8--py27_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(analysis_id, path(bam_files), path(bai_files), path(interval_file))

    output:
        tuple(val(analysis_id), path("${analysis_id}.${interval_file.baseName}.vcf"), path("${analysis_id}.${interval_file.baseName}.vcf.idx"), emit: vcf_file)

    script:
        def input_files = bam_files.collect{"$it"}.join(" --input_file ")
        """
        java -Xmx${task.memory.toGiga()-4}G -jar ${params.gatk_path} -T HaplotypeCaller \
        --reference_sequence ${params.genome} \
        --input_file ${input_files} \
        --intervals ${interval_file} \
        --out ${analysis_id}.${interval_file.baseName}.vcf \
        ${params.optional}
        """
}

process HaplotypeCallerGVCF {
    tag {"GATK HaplotypeCallerGVCF ${sample_id} - ${interval_file.baseName}"}
    label 'GATK_3_8_1_0_gf15c1c3ef'
    label 'GATK_3_8_1_0_gf15c1c3ef_HaplotypeCallerGVCF'
    container = 'quay.io/biocontainers/gatk:3.8--py27_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(bam_file), path(bai_file), path(interval_file))

    output:
        tuple(val(sample_id), path("${sample_id}_${interval_file.baseName}.g.vcf"), path("${sample_id}_${interval_file.baseName}.g.vcf.idx"), path(interval_file), emit: vcf_file)

    script:
        """
        java -Xmx${task.memory.toGiga()-4}G -jar ${params.gatk_path} -T HaplotypeCaller \
        --reference_sequence ${params.genome} \
        --input_file ${bam_file} \
        --intervals ${interval_file} \
        --out ${sample_id}_${interval_file.baseName}.g.vcf \
        --emitRefConfidence GVCF \
        ${params.optional}
        """
}
