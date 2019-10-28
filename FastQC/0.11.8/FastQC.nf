
process FastQC {
    tag {"FastQC ${sample_id} - ${rg_id}"}
    publishDir "$params.out_dir/$sample_id/FastQC", mode: 'copy'

    input:
    tuple sample_id, rg_id, file(fastq: "*")

    output:
    file "*_fastqc.{zip,html}"

    script:

    """
    fastqc --noextract -t ${task.cpus} $fastq
    """

}
