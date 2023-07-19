
process CreateVerifyIDIntensityContaminationMetricsFile {
    tag {"CreateVerifyIDIntensityContaminationMetricsFile ${sample_id}"}
    label 'PICARD_2_26_4_hdfd78af_0'
    label 'PICARD_2_26_4_hdfd78af_0_CreateVerifyIDIntensityContaminationMetricsFile'
    container = 'quay.io/biocontainers/picard:2.26.4--hdfd78af_0'
    shell = ['/bin/bash', '-euo', 'pipefail']
    
    input:
        tuple (val(sample_id), path(input_file))
    
    output:
        // Programm uses the defined OUTPUT parameter as prefix to '.verifyidintensity_metrics'
        tuple (val(sample_id), path("${sample_id}.verifyidintensity_metrics"))
    
    script:
        """
        picard "-Xmx${task.memory.toGiga()-4}G" -Dpicard.useLegacyParser=false \
        CreateVerifyIDIntensityContaminationMetricsFile \
        --INPUT ${input_file} \
        --OUTPUT ${sample_id}
        """
}