process GatherBaseRecalibrationTables {
    tag {"GATK GatherBaseRecalibrationTables ${sample_id}"}
    label 'GATK_4_3_0_0'
    label 'GATK_4_3_0_0_GatherBaseRecalibrationTables'
    container = 'broadinstitute/gatk:4.3.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bqsr_tables))

    output:
        tuple(val(sample_id), path("${sample_id}.recal.table"), emit : gathered_recalibration_tables)

    script:
        tables = bqsr_tables.join(' -I ')
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" GatherBQSRReports \
        -I $tables \
        --output ${sample_id}.recal.table
        """
}
