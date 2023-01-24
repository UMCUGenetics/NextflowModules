process GatherBqsrReports {
    tag {"GATK GatherBqsrReports ${sample_id}"}
    label 'GATK_4_3_0_0'
    label 'GATK_4_3_0_0_GatherBqsrReports'
    container = 'broadinstitute/gatk:4.3.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(recalibration_reports))

    output:
        tuple(val(sample_id), path("${sample_id}.recal_data.csv") emit: recalibration_report)

    script:
        def input_files = recalibration_reports.collect{"$it"}.join(" --input_file ")
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
        GatherBQSRReports \
        --input_file ${input_files} \
        --output ${sample_id}.recal_data.csv
        """
}
