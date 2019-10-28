
process GatherBaseRecalibrationTables {
    tag {"GatherBaseRecalibrationTables ${sample_id}"}
    label 'GATK'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.gatherbqsrtables_mem}" : ""
    publishDir "$params.out_dir/$sample_id/mapping", mode: 'copy'


    input:
      tuple sample_id, file(bqsr_tables)

    output:
      tuple sample_id, file("${sample_id}.recal.table")

    script:
    tables = bqsr_tables.join(' -I ')
    """
    gatk --java-options -Xmx${task.memory.toGiga()-4}g \
    GatherBQSRReports \
    -I $tables \
    --output ${sample_id}.recal.table \
    --tmp-dir /tmp
    """
}
