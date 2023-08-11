process CollectMultipleMetrics {
    tag {"GATK CollectMultipleMetrics ${sample_id}"}
    label 'GATK_4_3_0_0'
    label 'GATK_4_3_0_0_CollectMultipleMetrics'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'broadinstitute/gatk:4.3.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam))

    output:
        path("${sample_id}.multiple_metrics*", emit : multiple_metrics)

    script:
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" CollectMultipleMetrics \
        --tmp-dir \$TMPDIR \
        -I $bam \
        -O ${sample_id}.multiple_metrics\
        -R ${params.genome_fasta} \
        ${params.optional}
        """
}
