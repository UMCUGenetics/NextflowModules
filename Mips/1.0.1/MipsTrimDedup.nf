params.mips.trim_dedup.path
params.mips.trim_dedup.design_file
params.mips.trim_dedup.uuid_length
params.mips.trim_dedup.uuid_read

process MipsTrimDedup {
    tag {"MIPS TrimDedup ${sample_id} - ${rg_id}"}
    label 'MIPS_1.0.1'
    label 'MIPS_1.0.1_TrimDedup'
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
    python $params.mips.trim_dedup.path -d $params.mips.trim_dedup.design_file  -l $params.mips.trim_dedup.uuid_length -ur $params.mips.trim_dedup.uuid_read -r1 $r1_args -r2 $r2_args > output.log 2> output.err
    """
}
