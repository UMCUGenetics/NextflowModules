
process BaseRecalibrationTable {
    tag {"BaseRecalibrationTable ${sample_id}.${int_tag}"}
    label 'GATK'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.bqsrtable_mem}" : ""

    input:
      tuple sample_id, file(bam), file(bai), file(interval_file)

    output:
      tuple sample_id, file("${sample_id}.${int_tag}.recal.table")

    script:
    known = params.genome_known_sites ? '--known-sites ' + params.genome_known_sites.join(' --known-sites ') : ''
    int_tag = interval_file.toRealPath().toString().split("/")[-2]
    """
    gatk --java-options -Xmx${task.memory.toGiga()-4}g \
    BaseRecalibrator \
    --input $bam \
    --output ${sample_id}.${int_tag}.recal.table \
    --tmp-dir /tmp \
    -R $params.genome_fasta \
    $known \
    -L $interval_file
    """
}
