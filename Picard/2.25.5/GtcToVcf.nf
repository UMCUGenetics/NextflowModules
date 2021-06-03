process GtcToVcf {
    tag {"GtcToVcf ${sample_id}"}
    label 'PICARD_2_25_5'
    label 'PICARD_2_25_5_GtcToVcf'
    container = 'quay.io/biocontainers/picard:2.25.5--hdfd78af_0'
    shell = ['/bin/bash', '-euo', 'pipefail']
    
    input:
        tuple(val(sample_id), path(gtc_file))
    
    output:
        tuple(sample_id, path("${sample_id}.vcf.gz"), path("${sample_id}.vcf.gz.tbi"), emit : genotyped_vcfs)
    
    script:
        """
        picard -Xmx${task.memory.toGiga()-4}G \
        GtcToVcf \
        --TMP_DIR \$TMPDIR \
        --INPUT ${gtc_file} \
        --OUTPUT ${sample_id}.vcf.gz \
        --CLUSTER_FILE ${params.cluster_file} \
        --ILLUMINA_BEAD_POOL_MANIFEST_FILE ${params.bead_pool_manifest_file} \
        --EXTENDED_ILLUMINA_MANIFEST ${params.extended_chip_manifest_file} \
        --SAMPLE_ALIAS "${sample_id}" \
        --DO_NOT_ALLOW_CALLS_ON_ZEROED_OUT_ASSAYS true \
        --REFERENCE_SEQUENCE ${params.genome} \
        --MAX_RECORDS_IN_RAM 100000 \
        --CREATE_INDEX true \
        ${params.optional}
        """
}