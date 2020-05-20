process HaplotypeCaller {
    tag {"GATK HaplotypeCaller ${analysis_id} - ${interval_file.baseName}"}
    label 'GATK_3_8_1_0_gf15c1c3ef'
    label 'GATK_3_8_1_0_gf15c1c3ef_HaplotypeCaller'
    container = 'quay.io/biocontainers/gatk:3.8--py27_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        analysis_id
        tuple(path(bam_files), path(bai_files))
        path(interval_file)

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
