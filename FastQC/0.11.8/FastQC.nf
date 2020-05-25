process FastQC {
    tag {"FastQC ${sample_id} - ${rg_id}"}
    label 'FASTQC_0_11_8'
    container = 'quay.io/biocontainers/fastqc:0.11.8--1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, rg_id, path(fastq))

    output:
        path("*_fastqc.{zip,html}", emit: report)

    script:
        """
        fastqc ${params.optional} -t ${task.cpus} ${fastq}
        """
}
