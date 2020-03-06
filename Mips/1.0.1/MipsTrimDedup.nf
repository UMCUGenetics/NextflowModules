process MipsTrimDedup {
    tag {"MIPS TrimDedup ${sample_id} - ${rg_id}"}
    label 'MIPS_1_0_1'
    label 'MIPS_1_0_1_TrimDedup'
    // container = 'container_url' not available
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, rg_id, file(r1_fastqs: "*"), file(r2_fastqs: "*")

    output:
    tuple sample_id, rg_id, file('*_LMergedTrimmedDedup_R1_*.fastq.gz'), file('*_LMergedTrimmedDedup_R2_*.fastq.gz')

    script:
    def r1_args = r1_fastqs.collect{ "$it" }.join(" ")
    def r2_args = r2_fastqs.collect{ "$it" }.join(" ")

    rg_id = "${sample_id}_MergedTrimmedDedup"

    """
    python $params.trim_dedup_path -d $params.design_file  -l $params.uuid_length -ur $params.uuid_read -r1 $r1_args -r2 $r2_args
    """
}
