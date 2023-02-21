process BaseRecalibrator {
    tag {"GATK BaseRecalibrator ${sample_id} - ${region}"}
    label 'GATK_4_3_0_0'
    label 'GATK_4_3_0_0_BaseRecalibrator'
    container = 'broadinstitute/gatk:4.3.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam_file), path(bai_file), val(region))

    output:
        tuple(val(sample_id), val(region), path("${bam_file.baseName}.${region}.recal_data.csv"), emit: recalibration_report)

    script:
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
        BaseRecalibrator \
        --reference ${params.genome_fasta} \
        --input ${bam_file} \
        --use-original-qualities \
        --output ${bam_file.baseName}.${region}.recal_data.csv \
        --intervals ${region} \
        $params.optional
        """
}

process BaseRecalibratorApplyBQSR {
    // Combined process for BaseRecalibrator and ApplyBQSR
    tag {"GATK BaseRecalibratorApplyBQSR ${sample_id} - ${region}"}
    label 'GATK_4_3_0_0'
    label 'GATK_4_3_0_0_BaseRecalibratorApplyBQSR'
    container = 'broadinstitute/gatk:4.3.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam_file), path(bai_file), val(region))

    output:
        tuple(val(sample_id), path("${bam_file.baseName}.bqsr.${region}.bam"), path("${bam_file.baseName}.bqsr.${region}.bai"), emit: bam_file)
        tuple(val(sample_id), path("${bam_file.baseName}.${region}.recal_data.csv"), emit: recalibration_report)

    script:
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
        BaseRecalibrator \
        --reference ${params.genome_fasta} \
        --input ${bam_file} \
        --use-original-qualities \
        --output ${bam_file.baseName}.${region}.recal_data.csv \
        --intervals ${region} \
        $params.optional_br

        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
        ApplyBQSR \
        --reference ${params.genome_fasta} \
        --input ${bam_file} \
        --use-original-qualities \
        --output ${bam_file.baseName}.bqsr.${region}.bam \
        --bqsr-recal-file ${bam_file.baseName}.${region}.recal_data.csv \
        --intervals ${region}
        """
}