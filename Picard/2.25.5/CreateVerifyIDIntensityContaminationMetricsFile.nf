
process CreateVerifyIDIntensityContaminationMetricsFile {
    tag {"CreateVerifyIDIntensityContaminationMetricsFile ${sample_id}"}
    label 'PICARD_2_25_5'
    label 'PICARD_2_25_5_CreateVerifyIDIntensityContaminationMetricsFile'
    container = 'quay.io/biocontainers/picard:2.25.5--hdfd78af_0'
    shell = ['/bin/bash', '-euo', 'pipefail']
    
    input:
        tuple (sample_id, path(input_file))
    
    output:
        tuple (sample_id, path("${sample_id}_verifyidintensity_metrics"))
    
    script:
        """
        picard -Xmx${task.memory} -Dpicard.useLegacyParser=false \
        CreateVerifyIDIntensityContaminationMetricsFile \
        --INPUT ${input_file} \
        --OUTPUT ${sample_id}_verifyidintensity_metrics
        """
}