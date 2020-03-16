process HaplotypeCaller {
    tag {"GATK HaplotypeCaller ${sample_id} - ${rg_id}"}
    label 'GATK_3_8_1_0_gf15c1c3ef'
    label 'GATK_3_8_1_0_gf15c1c3ef_HaplotypeCaller'
    container = 'quay.io/biocontainers/gatk:3.8--py27_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple val(analysis_id), file(bam_files), file(bai_files), file(interval_file)

    output:
    tuple val(analysis_id), file("${analysis_id}.${interval_file.baseName}.vcf"), file("${analysis_id}.${interval_file.baseName}.vcf.idx")

    script:
    def input_files = bam_files.collect{"$it"}.join("--input_file ")
    """
    java -Xmx${task.memory.toGiga()-4}G -jar $params.gatk_path -T HaplotypeCaller --reference_sequence $params.genome --input_file $input_files intervals ${interval_file} --out ${analysis_id}.${interval_file.baseName}.vcf $params.optional
    """
}
