params.bwa.mem.genome
params.bwa.mem.optional

process MEM {
    tag {"BWA MEM ${sample_id} - ${rg_id}"}
    label 'BWA_0_7_17'
    label 'BWA_0_7_17_MEM'
    container = 'quay.io/biocontainers/bwa:0.7.17--hed695b0_6'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, rg_id, file(fastq: "*")

    output:
    tuple sample_id, rg_id, file("${rg_id}.sam")

    script:
    def barcode = rg_id.split('_')[1]
    def bwa_readgroup = "\"@RG\\tID:${rg_id}\\tSM:${sample_id}\\tPL:ILLUMINA\\tLB:${sample_id}\\tPU:${barcode}\""

    """
    bwa mem -t ${task.cpus} -R $bwa_readgroup $params.bwa.mem.optional $params.bwa.mem.genome $fastq  > ${rg_id}.sam
    """
}
