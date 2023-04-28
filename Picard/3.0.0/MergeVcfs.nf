process MergeVcfs {
    tag {"PICARD MergeVcfs"}
    label 'PICARD_3_0_0'
    label 'PICARD_3_0_0_MergeVcfs'
    container = 'quay.io/biocontainers/picard:3.0.0--hdfd78af_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(analysis_id), path(vcf_files), path(vcf_idx_files))

    output:
        tuple(val(analysis_id), path("${analysis_id}.vcf"), path("${analysis_id}.vcf.idx"), emit:vcf_file)

    script:
        def input_files = vcf_files.collect{"$it"}.join(" --INPUT ")
        """
        picard -Xmx${task.memory.toGiga()-4}G MergeVcfs --TMP_DIR \$TMPDIR \
        --INPUT ${input_files} \
        --OUTPUT ${analysis_id}.vcf
        """
}
