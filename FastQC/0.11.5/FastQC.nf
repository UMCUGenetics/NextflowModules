process FastQC {
    tag {"FastQC ${sample_id} - ${rg_id}"}
    label 'FASTQC_0_11_5'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:fastqc-0.11.5'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, rg_id, file(fastq: "*")

    output:
    file "*_fastqc.{zip,html}"

    script:
    """
    fastqc ${params.optional} -t ${task.cpus} $fastq
    """
}
