process HaplotypeCaller {
    tag {"GATK HaplotypeCaller ${analysis_id} - ${interval_file.baseName}"}
    label 'GATK_4_2_0_0'
    label 'GATK_4_2_0_0_HaplotypeCaller'
    container = 'broadinstitute/gatk:4.2.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(analysis_id), path(bam_files), path(bai_files), path(interval_file))

    output:
        tuple(val(analysis_id), path("${analysis_id}.${interval_file.baseName}.vcf"), path("${analysis_id}.${interval_file.baseName}.vcf.idx"), emit: vcf_file)

    script:
        def input_files = bam_files.collect{"$it"}.join(" --input ")
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}G" HaplotypeCaller \
        --reference ${params.genome} \
        --input ${input_files} \
        --intervals ${interval_file} \
        --output ${analysis_id}.${interval_file.baseName}.vcf \
        ${params.optional}
        """
}

process HaplotypeCallerGVCF {
    tag {"GATK HaplotypeCallerGVCF ${sample_id} - ${interval_file.baseName}"}
    label 'GATK_4_2_0_0_gf15c1c3ef'
    label 'GATK_4_2_0_0_gf15c1c3ef_HaplotypeCallerGVCF'
    container = 'broadinstitute/gatk:4.2.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam_file), path(bai_file), path(interval_file))

    output:
        tuple(val(sample_id), path("${sample_id}_${interval_file.baseName}.g.vcf"), path("${sample_id}_${interval_file.baseName}.g.vcf.idx"), path(interval_file), emit: vcf_file)

    script:
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}G" HaplotypeCaller \
        --reference ${params.genome} \
        --input ${bam_file} \
        --intervals ${interval_file} \
        --output ${sample_id}_${interval_file.baseName}.g.vcf \
        --emit-ref-confidence GVCF \
        ${params.optional}
        """
}
