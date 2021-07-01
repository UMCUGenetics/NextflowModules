
process CreateVerifyIDIntensityContaminationMetricsFile {
    tag {"CreateVerifyIDIntensityContaminationMetricsFile ${sample_id}"}
    label 'PICARD_2_25_5'
    label 'PICARD_2_25_5_CreateVerifyIDIntensityContaminationMetricsFile'
    container = 'quay.io/biocontainers/picard:2.25.5--hdfd78af_0'
    shell = ['/bin/bash', '-euo', 'pipefail']
    
    input:
        tuple (sample_id, path(input_file))
    
    output:
        // Programm uses the defined OUTPUT parameter as prefix to '.verifyidintensity_metrics'
        tuple (sample_id, path("${sample_id}.verifyidintensity_metrics"))
    
    script:
        """
        picard "-Xmx${task.memory.toGiga()-4}G" -Dpicard.useLegacyParser=false \
        CreateVerifyIDIntensityContaminationMetricsFile \
        --INPUT ${input_file} \
        --OUTPUT ${sample_id}
        """
}