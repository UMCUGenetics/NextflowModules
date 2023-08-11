process MEM {
    tag {"BWA_MEM2 MEM ${sample_id} - ${rg_id}"}
    label 'BWA_MEM2_2_2_1'
    label 'BWA_MEM2_2_2_1_MEM'
    container = 'quay.io/blcdsdockerregistry/bwa-mem2_samtools-1.12:2.2.1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), val(rg_id), path(fastq))

    output:
        tuple(val(sample_id), val(rg_id), path("${fastq[0].simpleName}.sam"), emit: sam_file)

    script:
        def barcode = rg_id.split('_')[1]
        def readgroup = "\"@RG\\tID:${rg_id}\\tSM:${sample_id}\\tPL:ILLUMINA\\tLB:${sample_id}\\tPU:${barcode}\""

        """
        bwa-mem2 mem -t ${task.cpus} -R ${readgroup} ${params.optional} ${params.genome} ${fastq} > ${fastq[0].simpleName}.sam
        """
}
