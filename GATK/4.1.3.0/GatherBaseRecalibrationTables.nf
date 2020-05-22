
process GatherBaseRecalibrationTables {
    tag {"GATK GatherBaseRecalibrationTables ${sample_id}"}
    label 'GATK_4_1_3_0'
    label 'GATK_4_1_3_0_GatherBaseRecalibrationTables'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:gatk4.1.3.0'
    shell = ['/bin/bash', '-euo', 'pipefail']
    input:
        tuple (sample_id, path(bqsr_tables))

    output:
        tuple (sample_id, path("${sample_id}.recal.table"), emit : gathered_recalibration_tables)

    script:
        tables = bqsr_tables.join(' -I ')
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
        GatherBQSRReports \
        -I $tables \
        --output ${sample_id}.recal.table \
        """
}
