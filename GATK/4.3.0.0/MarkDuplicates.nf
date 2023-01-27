process MarkDuplicatesMerge {
    tag {"GATK MarkDuplicatesMerge ${sample_id}"}
    label 'GATK_4_3_0_0'
    label 'GATK_4_3_0_0_MarkDuplicatesMerge'
    container = 'broadinstitute/gatk:4.3.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(bam_files))

    output:
        tuple(sample_id, path("${sample_id}.markdup.bam"), path("${sample_id}.markdup.bam.bai"), emit: bam_file)
        tuple(sample_id, path("${sample_id}.duplicate_metrics.txt"), emit: metrics_file)

    script:
        def input_files = bam_files.collect{"$it"}.join(" --INPUT ")
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
        MarkDuplicates \
        --INPUT ${input_files} \
        --OUTPUT ${sample_id}.markdup.bam \
        --METRICS_FILE ${sample_id}.duplicate_metrics.txt \
        $params.optional
        """
}