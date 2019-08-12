


process BWAMapping {
    tag {"BWAMapping ${sample_id} - ${rg_id}"}
    publishDir "$params.out_dir/$sample_id/mapping", mode: 'copy'
    container = '/hpc/cog_bioinf/cuppen/personal_data/sander/scripts/Nextflow/Singularity-images/bwa-0.7.17_samtools-1.9.squashfs'
    cpus 12
    penv 'threaded'
    memory '32 GB'
    time '18h'

    input:
    set sample_id, rg_id, file(fastq: "*")

    output:
    set sample_id, rg_id, file("${rg_id}_sorted.bam"),file("${rg_id}_sorted.bai")

    script:

    def barcode = rg_id.split('_')[1]
    def bwa_readgroup = "\"@RG\\tID:${rg_id}\\tSM:${sample_id}\\tPL:ILLUMINA\\tLB:${sample_id}\\tPU:${barcode}\""

    """
    set -o pipefail
    bwa mem -M -t ${task.cpus} -c 100 -R $bwa_readgroup $params.genome $fastq | \
    samtools sort > ${rg_id}_sorted.bam
    samtools index ${rg_id}_sorted.bam ${rg_id}_sorted.bai
    """
}
