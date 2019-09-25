params.genome

process MEM {
    container = 'quay.io/biocontainers/bwa:0.7.17--hed695b0_6'
    tag {"BWA MEM ${sample_id} - ${rg_id}"}
    publishDir "$params.outdir/$sample/BWA_MEM", mode: 'copy'
    cpus 1
    memory '10 GB'
    time '1h'

    input:
    set sample, rg_id, file(r1_fastq), file(r2_fastq)

    output:
    set sample, rg_id, file("${rg_id}.sam")

    script:
    def barcode = rg_id.split('_')[1]
    def bwa_readgroup = "\"@RG\\tID:${rg_id}\\tSM:${sample}\\tPL:ILLUMINA\\tLB:${sample}\\tPU:${barcode}\""

    """
    bwa mem -t ${task.cpus} -c 100 -M -R $bwa_readgroup $params.genome $r1_fastq $r2_fastq  > ${rg_id}.sam
    """
}
