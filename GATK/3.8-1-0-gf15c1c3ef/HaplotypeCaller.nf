process HaplotypeCaller {
    tag {"GATK HaplotypeCaller ${analysis_id} - ${interval_file.baseName}"}
    label 'GATK_3_8_1_0_gf15c1c3ef'
    label 'GATK_3_8_1_0_gf15c1c3ef_HaplotypeCaller'
    container = 'quay.io/biocontainers/gatk:3.8--py27_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(analysis_id, path(bam_files), path(bai_files), path(interval_file))

    output:
        tuple(val(analysis_id), file("${analysis_id}.${interval_file.baseName}.vcf"), file("${analysis_id}.${interval_file.baseName}.vcf.idx"), emit: vcf_file)

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
        tuple(val(sample_id), file("${sample_id}.${interval_file.baseName}.g.vcf."), file("${sample_id}.${interval_file.baseName}.g.vcf.idx"), emit: vcf_file)

    script:
        """
        java -Xmx${task.memory.toGiga()-4}G -jar ${params.gatk_path} -T HaplotypeCaller \
        --reference_sequence ${params.genome} \
        --input_file ${bam_file} \
        --intervals ${interval_file} \
        --out ${analysis_id}.${interval_file.baseName}.g.vcf \
        --emitRefConfidence GVCF \
        --GVCFGQBands 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,70,80,90,99 \
        ${params.optional}
        """
}