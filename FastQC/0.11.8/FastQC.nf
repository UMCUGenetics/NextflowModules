params.fastqc.optional

process FastQC {
    tag {"FastQC ${sample_id} - ${rg_id}"}
    label 'FASTQC_0_11_8'
    container = 'quay.io/biocontainers/fastqc:0.11.8--1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, rg_id, file(r1_fastq), file(r2_fastq)

    output:
    file "*_fastqc.{zip,html}"

    script:
    """
    fastqc ${params.fastqc.optional} -t ${task.cpus} $r1_fastq $r2_fastq
    """
}
