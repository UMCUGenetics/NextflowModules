process FastQC {
    container = 'quay.io/biocontainers/fastqc:0.11.8--1'
    tag {"FastQC ${sample_id} - ${rg_id}"}

    input:
    set sample_id, rg_id, file(r1), file(r2)

    output:
    file "*_fastqc.{zip,html}"

    script:
    """
    fastqc --noextract -t ${task.cpus} $r1 $r2
    """

}
