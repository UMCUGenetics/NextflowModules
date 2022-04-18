process Mapping {
    tag {"Winnowmap ${sample_id} - ${fastq_id}"}
    label 'Winnowmap_2_0_3'
    container = 'quay.io/biocontainers/winnowmap:2.03--h5b5514e_1'
    shell = ['/bin/bash', '-euo', 'pipefail']
    
    input:
        tuple(path(fastq), rg_id, sample_id, run_id)

    output:
        tuple (sample_id, fastq_id, path("${fastq_id}.sam"), emit: mapped_sams)

    script:
        readgroup = "\"@RG\\tID:${fastq.baseName}\\tSM:${sample_id}\\tPL:ONT\\tLB:${sample_id}\""
        fastq_id = fastq.toString().replace('.fastq.gz', '')
        """
        winnowmap -a -t ${task.cpus} -R $readgroup $params.optional -o ${fastq_id}.sam $params.genome_fasta ${fastq} 
        """
}
