process CombineGVCFs {
    tag {"GATK CombineGVCFs ${sample_id}"}
    label 'GATK_4_3_0_0'
    label 'GATK_4_3_0_0_CombineGVCFs'
    container = 'broadinstitute/gatk:4.3.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(gvcf_files), path(gvcf_idx_files))

    output:
        tuple(
            val(sample_id),
            path("${sample_id}.g.vcf"),
            path("${sample_id}.g.vcf.idx"),
            emit: vcf_file
        )

    script:
        def input_files = gvcf_files.collect{"$it"}.join(" --variant ")
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
        CombineGVCFs \
        --reference ${params.genome_fasta} \
        --variant ${input_files} \
        --output ${sample_id}.g.vcf \
        $params.optional
        """
}
