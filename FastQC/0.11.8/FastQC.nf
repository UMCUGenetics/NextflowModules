
process FastQC {
    tag {"FastQC ${sample_id} - ${rg_id}"}
    publishDir "$params.out_dir/$sample_id/FastQC", mode: 'copy'
    container = '/hpc/cog_bioinf/cuppen/personal_data/sander/scripts/Nextflow/Singularity-images/fastqc-0.11.5.squashfs'
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
    fastqc --noextract -t ${task.cpus} $fastq
    """

}
