process BWAMapping {
    tag {"BWA_MEM2 Mem ${sample_id} - ${rg_id}"}
    label 'BWA_MEM2_2_2_1'
    label 'BWA_MEM2_2_2_1_Mem'
    container = 'library://blcdsdockerregistry/bwa-mem2_samtools-1.12:2.2.1'
    shell = ['/bin/bash', '-euo', 'pipefail']
    
    input:
        tuple(val(sample_id), val(rg_id), path(fastq))

    output:
        tuple(val(sample_id), val(rg_id), path("${rg_id}_sorted.bam"), path("${rg_id}_sorted.bai"), emit: mapped_bams)

    script:
        def barcode = rg_id.split('_')[1]
        def bwa_readgroup = "\"@RG\\tID:${rg_id}\\tSM:${sample_id}\\tPL:ILLUMINA\\tLB:${sample_id}\\tPU:${barcode}\""

        """
        bwa-mem2 mem $params.optional -t ${task.cpus} -R $bwa_readgroup $params.genome_fasta $fastq | \
        samtools sort > ${rg_id}_sorted.bam
        samtools index ${rg_id}_sorted.bam ${rg_id}_sorted.bai
        """
}
