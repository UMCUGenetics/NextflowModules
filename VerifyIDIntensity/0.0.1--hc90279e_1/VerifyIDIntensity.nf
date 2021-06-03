process VerifyIDIntensity {
    tag {"VerifyIDIntensity ${sample_id}"}
    label 'VERIFYIDINTENSITY_0_0_1_hc90279e_1'
    label 'VERIFYIDINTENSITY_0_0_1_hc90279e_1_VerifyIDIntensity'
    container = 'quay.io/biocontainers/verifyidintensity:0.0.1--hc90279e_1'
    shell = ['/bin/bash', '-eo', 'pipefail']

    input:
        tuple (
            val(sample_id),
            // path(input_vcf),
            // path(input_vcf_index),
            val(num_samples),
            path(num_markers_file),
            path(adpc_file)
        )

    output:
        tuple (val("${sample_id}"), path("${sample_id}_verifyIDIntensity.txt"))

    script:
        """
        verifyIDintensity -m ${num_markers} -n ${num_samples} -i ${adpc_file} -v -p > ${sample_id}_verifyIDIntensity.txt
        """
}