process BaseRecalibrator {
    tag {"GATK BaseRecalibrator ${sample_id} - ${chr}"}
    label 'GATK_4_3_0_0'
    label 'GATK_4_3_0_0_BaseRecalibrator'
    container = 'broadinstitute/gatk:4.3.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam_file), path(bai_file), chr)

    output:
        tuple(val(sample_id), path("${bam_file.baseName}.${chr}.recal_data.csv") emit: recalibration_report)

    script:
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
        BaseRecalibrator \
        --reference ${params.genome_fasta} \
        --input $bam \
        --use-original-qualities \
        --output ${bam_file.baseName}.${chr}.recal_data.csv \
        --intervals ${chr} \
        $params.optional
        """
}