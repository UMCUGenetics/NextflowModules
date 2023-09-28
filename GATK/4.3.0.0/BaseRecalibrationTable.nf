process BaseRecalibrationTable {
    tag {"GATK BaseRecalibrationTable ${sample_id}.${int_tag}"}
    label 'GATK_4_3_0_0'
    label 'GATK_4_3_0_0_BaseRecalibrationTable'
    container = 'broadinstitute/gatk:4.3.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam), path(bai), path(interval_file))

    output:
        tuple(val(sample_id), path("${sample_id}.${int_tag}.recal.table"), emit: recalibration_tables)

    script:
        known = params.genome_known_sites ? '--known-sites ' + params.genome_known_sites.join(' --known-sites ') : ''
        int_tag = interval_file.toRealPath().toString().split("/")[-2]
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" BaseRecalibrator \
        --tmp-dir \$TMPDIR \
        --input $bam \
        --output ${sample_id}.${int_tag}.recal.table \
        -R ${params.genome_fasta} \
        $known \
        -L $interval_file
        """
}

