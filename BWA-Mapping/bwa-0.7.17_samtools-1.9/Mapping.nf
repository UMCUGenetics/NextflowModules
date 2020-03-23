

process BWAMapping {
    tag {"BWA_Mem ${sample_id} - ${rg_id}"}
    label 'BWA_0_7_17'
    label 'BWA_0_7_17_Mem'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:bwa-0.7.17_samtools-1.9'

    input:
    tuple sample_id, rg_id, file(fastq: "*")

    output:
    tuple sample_id, rg_id, file("${rg_id}_sorted.bam"),file("${rg_id}_sorted.bai")

    script:

    def barcode = rg_id.split('_')[1]
    def bwa_readgroup = "\"@RG\\tID:${rg_id}\\tSM:${sample_id}\\tPL:ILLUMINA\\tLB:${sample_id}\\tPU:${barcode}\""

    """
    set -o pipefail
    bwa mem $params.optional -t ${task.cpus} -R $bwa_readgroup $params.genome_fasta $fastq | \
    samtools sort > ${rg_id}_sorted.bam
    samtools index ${rg_id}_sorted.bam ${rg_id}_sorted.bai
    """
}
