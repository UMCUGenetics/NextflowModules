process CollectWGSMetrics {
    tag {"GATK CollectWGSMetrics ${sample_id}"}
    label 'GATK_4_3_0_0'
    label 'GATK_4_3_0_0_CollectWGSMetrics'
    container = 'broadinstitute/gatk:4.3.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam))

    output:
        path("${sample_id}.wgs_metrics.txt" , emit: wgs_metrics)

    script:
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" CollectWgsMetrics \
        --TMP_DIR \$TMPDIR \
        -I $bam \
        -O ${sample_id}.wgs_metrics.txt \
        -R ${params.genome_fasta} \
        ${params.optional}

        sed -i 's/picard\\.analysis\\.WgsMetrics/picard\\.analysis\\.CollectWgsMetrics\\\$WgsMetrics/' ${sample_id}.wgs_metrics.txt
        """
}
