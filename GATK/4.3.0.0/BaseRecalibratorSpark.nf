process BaseRecalibratorSpark {
    tag {"GATK BaseRecalibratorSpark ${sample_id} - ${chr}"}
    label 'GATK_4_3_0_0'
    label 'GATK_4_3_0_0_BaseRecalibratorSpark'
    container = 'broadinstitute/gatk:4.3.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam_file), path(bai_file))

    output:
        tuple(val(sample_id), path("${bam_file.baseName}.recal_data.csv"), emit: recalibration_report)

    script:
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
        BaseRecalibratorSpark \
        --spark-master local[${task.cpus}]
        --reference ${params.genome_fasta} \
        --input ${bam_file} \
        --use-original-qualities \
        --output ${bam_file.baseName}.recal_data.csv \
        $params.optional
        """
}
