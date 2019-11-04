params.genome

process MEM {
    container = 'quay.io/biocontainers/bwa:0.7.17--hed695b0_6'
    tag {"BWAMEM ${sample_id} - ${rg_id}"}

    input:
    set sample_id, rg_id, file(r1_fastq), file(r2_fastq)

    output:
    set sample_id, rg_id, file("${rg_id}.sam")

    script:
    def barcode = rg_id.split('_')[1]
    def bwa_readgroup = "\"@RG\\tID:${rg_id}\\tSM:${sample_id}\\tPL:ILLUMINA\\tLB:${sample_id}\\tPU:${barcode}\""

    """
    bwa mem -t ${task.cpus} -c 100 -M -R $bwa_readgroup $params.genome $r1_fastq $r2_fastq  > ${rg_id}.sam
    """
}
