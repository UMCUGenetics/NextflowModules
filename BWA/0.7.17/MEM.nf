process MEM {
    tag {"BWA MEM ${sample_id} - ${rg_id}"}
    label 'BWA_0_7_17'
    label 'BWA_0_7_17_MEM'
    container = 'quay.io/biocontainers/bwa:0.7.17--hed695b0_6'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, rg_id, path(fastq))

    output:
        tuple(sample_id, rg_id, path("${fastq[0].simpleName}.sam"), emit: sam_file)

    script:
        def barcode = rg_id.split('_')[1]
        def readgroup = "\"@RG\\tID:${rg_id}\\tSM:${sample_id}\\tPL:ILLUMINA\\tLB:${sample_id}\\tPU:${barcode}\""

        """
        bwa mem -t ${task.cpus} -R ${readgroup} ${params.optional} ${params.genome} ${fastq} > ${fastq[0].simpleName}.sam
        """
}
