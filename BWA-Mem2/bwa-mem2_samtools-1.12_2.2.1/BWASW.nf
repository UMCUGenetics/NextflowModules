process BWASW {
    tag {"BWA_MEM2 BWASW ${sample_id} - ${rg_id}"}
    label 'BWA_MEM2_2_2_1'
    label 'BWA_MEM2_2_2_1_BWASW'
    container = 'blcdsdockerregistry/bwa-mem2_samtools-1.12:2.2.1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), val(rg_id), path(fastq))

    output:
        tuple(val(sample_id), val(rg_id_), path("${fastq[0].simpleName}.sam"), emit: sam_file)

    script:
        """
        bwa-mem2 bwasw -t ${task.cpus} ${params.optional} ${params.genome} ${fastq} > ${fastq[0].simpleName}.sam
        """
}
