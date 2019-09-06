process FastQC {
    container = 'quay.io/biocontainers/fastqc:0.11.8--1'
    tag {"FastQC ${sample_id} - ${rg_id}"}
    publishDir "$params.outdir/$sample_id/FastQC", mode: 'copy'

    cpus 1
    penv 'threaded'
    memory '1 GB'
    time '1h'

    input:
    set sample_id, rg_id, file(fastq_files: "*")

    output:
    file "*_fastqc.{zip,html}"

    script:
    """
    fastqc --noextract -t ${task.cpus} $fastq_files
    """

}
