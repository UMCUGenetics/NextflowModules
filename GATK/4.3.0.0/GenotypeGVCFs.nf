process GenotypeGVCFs {
    tag {"GATK GenotypeGVCFs ${analysis_id}"}
    label 'GATK_4_3_0_0'
    label 'GATK_4_3_0_0_GenotypeGVCFs'
    container = 'broadinstitute/gatk:4.3.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(analysis_id), path(gvcf_files), path(gvcf_idx_files), path(interval_file))

    output:
        tuple(
            val(analysis_id),
            path("${analysis_id}.vcf"),
            path("${analysis_id}.vcf.idx"),
            emit: vcf_file
        )

    script:
        def input_files = gvcf_files.collect{"$it"}.join(" --variant ")
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
        GenotypeGVCFs \
        --reference ${params.genome_fasta} \
        --variant ${input_files} \
        --output ${analysis_id}.vcf \
        --intervals ${interval_file} \
        $params.optional
        """
}
