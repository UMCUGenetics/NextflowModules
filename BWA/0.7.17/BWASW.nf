process BWASW {
    tag {"BWA BWASW ${sample_id} - ${rg_id}"}
    label 'BWA_0_7_17'
    label 'BWA_0_7_17_BWASW'
    container = 'quay.io/biocontainers/bwa:0.7.17--hed695b0_6'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, rg_id, file(fastq: "*")

    output:
    tuple sample_id, rg_id, file("${rg_id}.sam")

    script:
    """
    bwa bwasw -t ${task.cpus} ${params.bwa.bwasw.optional} ${params.bwa.bwasw.genome} $fastq > ${rg_id}.sam
    """
}
