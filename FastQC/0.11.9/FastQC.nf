process FastQC {
    tag {"FastQC ${sample_id} - ${rg_id}"}
    label 'FASTQC_0_11_9'
    container = 'quay.io/biocontainers/fastqc:0.11.9--hdfd78af_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), val(rg_id), path(fastq))

    output:
        path("*_fastqc.{zip,html}", emit: report)

    script:
        """
        fastqc ${params.optional} -t ${task.cpus} ${fastq}
        """
}
