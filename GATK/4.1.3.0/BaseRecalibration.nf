

process BaseRecalibration {
    tag {"GATK_Applybqsr ${sample_id}.${int_tag}"}
    label 'GATK_4_1_3_0'
    label 'GATK_4_1_3_0_Applybqsr'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:gatk4.1.3.0'

    input:
      tuple sample_id, file(bam), file(bai),file(recal_table), file(interval_file)

    output:
      tuple sample_id, int_tag, file("${sample_id}.${int_tag}_recalibrated.bam"), file("${sample_id}.${int_tag}_recalibrated.bai"), file(interval_file)

    script:
    int_tag = interval_file.toRealPath().toString().split("/")[-2]
    """
    gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR"\
    ApplyBQSR \
    --input $bam \
    --output ${sample_id}.${int_tag}_recalibrated.bam \
    -R ${params.genome_fasta} \
    --create-output-bam-index true \
    --bqsr-recal-file ${recal_table} \
    -L $interval_file
    """
}
