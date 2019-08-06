params.bwa
params.samtools
params.genome

process MEM {
    tag "${sample}_bwa_mem"
    publishDir "$params.outdir/$sample/BWA_MEM", mode: 'copy'
    cpus 1
    penv 'threaded'
    memory '10 GB'
    time '1h'

    input:
    set val(sample), file(r1_fastq), file(r2_fastq)

    output:
    set val(sample), file("${sample}.bam"), file("${sample}.bai")

    script:
    def barcode = r1_fastq.getName().split('_')[1]
    def bwa_readgroup = "\"@RG\\tID:${sample}_${barcode}\\tSM:${sample}\\tPL:ILLUMINA\\tLB:${sample}\\tPU:${barcode}\""

    """
    $params.bwa mem -t ${task.cpus} -c 100 -M -R $bwa_readgroup $params.genome $r1_fastq $r2_fastq | $params.samtools view -b | $params.samtools sort > ${sample}.bam
    $params.samtools index ${sample}.bam ${sample}.bai
    """
}
