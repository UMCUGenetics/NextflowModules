
process BaseRecalibrationTable {
    tag {"GATK_Baserecalibrator ${sample_id}.${int_tag}"}
    label 'GATK_4_1_3_0'
    label 'GATK_4_1_3_0_Baserecalibrator'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:gatk4.1.3.0'

    input:
      tuple sample_id, file(bam), file(bai), file(interval_file)

    output:
      tuple sample_id, file("${sample_id}.${int_tag}.recal.table")

    script:
    known = params.genome_known_sites ? '--known-sites ' + params.genome_known_sites.join(' --known-sites ') : ''
    int_tag = interval_file.toRealPath().toString().split("/")[-2]
    """

    gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
    BaseRecalibrator \
    --input $bam \
    --output ${sample_id}.${int_tag}.recal.table \
    -R ${params.genome_fasta} \
    $known \
    -L $interval_file
    """
}
//-tmp-dir \$TMPDIR \
