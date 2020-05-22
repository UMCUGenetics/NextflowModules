

process BaseRecalibration {
    tag {"GATK BaseRecalibration ${sample_id}.${int_tag}"}
    label 'GATK_4_1_3_0'
    label 'GATK_4_1_3_0_BaseRecalibration'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:gatk4.1.3.0'
    shell = ['/bin/bash', '-euo', 'pipefail']
    input:
        tuple (sample_id, file(bam), path(bai),path(recal_table), path(interval_file))

    output:
        tuple (sample_id, int_tag, path("${sample_id}.${int_tag}_recalibrated.bam"), path("${sample_id}.${int_tag}_recalibrated.bai"), path(interval_file), emit: recalibrated_bams)

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
