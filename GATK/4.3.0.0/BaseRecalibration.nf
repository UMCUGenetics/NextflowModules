process BaseRecalibration {
    tag {"GATK BaseRecalibration ${sample_id}.${int_tag}"}
    label 'GATK_4_3_0_0'
    label 'GATK_4_3_0_0_BaseRecalibration'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'broadinstitute/gatk:4.3.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), file(bam), path(bai),path(recal_table), path(interval_file))

    output:
        tuple(val(sample_id), val(int_tag), path("${sample_id}.${int_tag}_recalibrated.bam"), path("${sample_id}.${int_tag}_recalibrated.bai"), path(interval_file), emit: recalibrated_bams)

    script:
        int_tag = interval_file.toRealPath().toString().split("/")[-2]
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" ApplyBQSR \
        --tmp-dir \$TMPDIR \
        --input $bam \
        --output ${sample_id}.${int_tag}_recalibrated.bam \
        -R ${params.genome_fasta} \
        --create-output-bam-index true \
        --bqsr-recal-file ${recal_table} \
        -L $interval_file
        """
}
