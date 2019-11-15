
process FastQC {
    tag {"FastQC ${sample_id} - ${rg_id}"}
    label 'FASTQC_0_11_8'

    input:
    tuple sample_id, rg_id, file(fastq: "*")

    output:
    file "*_fastqc.{zip,html}"

    script:
    """
    fastqc ${params.fastqc.toolOptions} -t ${task.cpus} $fastq
    """

}
