
process FastQC {
    tag {sample_id + "-" + rg_id}
    publishDir "$params.out_dir/$sample_id/FastQC", mode: 'copy'
    cpus 1
    penv 'threaded'
    memory '1 GB'
    time '1h'

    input:
    set sample_id, rg_id, file(fastq: "*")

    output:
    file "*_fastqc.{zip,html}"

    script:
    """
    $params.fastqc_path --noextract -t ${task.cpus} $fastq
    """

}
