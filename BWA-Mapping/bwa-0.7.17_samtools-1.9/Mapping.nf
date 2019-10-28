

process BWAMapping {
    tag {"BWAMapping ${sample_id} - ${rg_id}"}

    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.bwa_mem}" : ""

    input:
    tuple sample_id, rg_id, file(fastq: "*")

    output:
    tuple sample_id, rg_id, file("${rg_id}_sorted.bam"),file("${rg_id}_sorted.bai")

    script:

    def barcode = rg_id.split('_')[1]
    def bwa_readgroup = "\"@RG\\tID:${rg_id}\\tSM:${sample_id}\\tPL:ILLUMINA\\tLB:${sample_id}\\tPU:${barcode}\""

    """
    set -o pipefail
    bwa mem -M -t ${task.cpus} -c 100 -R $bwa_readgroup $params.genome_fasta $fastq | \
    samtools sort > ${rg_id}_sorted.bam
    samtools index ${rg_id}_sorted.bam ${rg_id}_sorted.bai
    """
}
