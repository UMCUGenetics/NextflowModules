process MEM {
    tag {"BWA-MEM2 MEM ${sample_id}"}
    label 'BWAMEM2_2_2_1'
    label 'BWAMEM2_2_2_1_MEM'
    container = 'quay.io/biocontainers/mulled-v2-e5d375990341c5aef3c9aff74f96f66f65375ef6:2cdf6bf1e92acbeb9b2834b1c58754167173a410-0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), val(rg_id), path(fastq))

    output:
        tuple(val(sample_id), val(rg_id), path("${rg_id}.bam"), path("${rg_id}.bai"), emit: mapped_bams)

    script:
        def barcode = rg_id.split('_')[1]
        def bwa_readgroup = "\"@RG\\tID:${rg_id}\\tSM:${sample_id}\\tPL:ILLUMINA\\tLB:${sample_id}\\tPU:${barcode}\""
        """
        bwa-mem2 mem $params.optional -t ${task.cpus} -R $bwa_readgroup $params.genome_fasta $fastq | \
        samtools sort -@ $task.cpus > ${rg_id}.bam
        samtools index ${rg_id}.bam ${rg_id}.bai
        """
}
