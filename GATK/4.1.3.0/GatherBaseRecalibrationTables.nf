
process GatherBaseRecalibrationTables {
    tag {"GATK_gatherbaserecalibrator ${sample_id}"}
    label 'GATK_4_1_3_0'
    label 'GATK_gatherbaserecalibrator_4_1_3_0'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.gatherbaserecalibrator.mem}" : ""

    input:
      tuple sample_id, file(bqsr_tables)

    output:
      tuple sample_id, file("${sample_id}.recal.table")

    script:
    tables = bqsr_tables.join(' -I ')
    """
    gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
    GatherBQSRReports \
    -I $tables \
    --output ${sample_id}.recal.table \
    """
}
