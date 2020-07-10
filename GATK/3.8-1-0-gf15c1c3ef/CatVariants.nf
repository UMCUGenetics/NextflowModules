process CatVariantsGVCF {
    tag {"GATK CatVariantsGVCF ${sample_id}"}
    label 'GATK_3_8_1_0_gf15c1c3ef'
    label 'GATK_3_8_1_0_gf15c1c3ef_CatVariantsGVCF'
    container = 'quay.io/biocontainers/gatk:3.8--py27_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(gvcf_files), path(gvcf_idx_files))

    output:
        tuple(sample_id, path("${sample_id}.g.vcf.gz"), path("${sample_id}.g.vcf.gz.tbi"), emit:vcf_file)

    script:
        def input_files = gvcf_files.collect{"$it"}.join(" -V ")
        """
        java -Xmx${task.memory.toGiga()-4}G -cp ${params.gatk_path} org.broadinstitute.gatk.tools.CatVariants --reference ${params.genome} -V ${input_files} --outputFile ${sample_id}.g.vcf.gz ${params.optional}
        """
}
