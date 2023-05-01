process GenotypeGVCFs {
    tag {"GATK GenotypeGVCFs ${analysis_id}"}
    label 'GATK_4_3_0_0'
    label 'GATK_4_3_0_0_GenotypeGVCFs'
    container = 'broadinstitute/gatk:4.3.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(analysis_id), path(gvcf_file), path(gvcf_idx_file))

    output:
        tuple(
            val(analysis_id),
            path("${analysis_id}.vcf"),
            path("${analysis_id}.vcf.idx"),
            emit: vcf_file
        )

    script:
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
        GenotypeGVCFs \
        --reference ${params.genome_fasta} \
        --variant ${gvcf_file} \
        --output ${analysis_id}.vcf \
        $params.optional
        """
}

process GenotypeGVCFsInterval {
    tag {"GATK GenotypeGVCFsInterval ${analysis_id}"}
    label 'GATK_4_3_0_0'
    label 'GATK_4_3_0_0_GenotypeGVCFs'
    label 'GATK_4_3_0_0_GenotypeGVCFsInterval'
    container = 'broadinstitute/gatk:4.3.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(analysis_id), path(gvcf_file), path(gvcf_idx_file), path(interval_file))

    output:
        tuple(
            val(analysis_id),
            path("${analysis_id}.${interval_file.baseName}.vcf"),
            path("${analysis_id}.${interval_file.baseName}.vcf.idx"),
            emit: vcf_file
        )

    script:
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
        GenotypeGVCFs \
        --reference ${params.genome_fasta} \
        --variant ${gvcf_file} \
        --output ${analysis_id}.${interval_file.baseName}.vcf\
        --intervals ${interval_file} \
        $params.optional
        """
}