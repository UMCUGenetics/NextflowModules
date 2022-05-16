process Mapping {
    tag {"Minimap2 ${sample_id} - ${fastq_id}"}
    label 'Minimap_2_2_4'
    container = 'quay.io/biocontainers/minimap2:2.24--h5bf99c6_0'
    shell = ['/bin/bash', '-euo', 'pipefail']
    
    input:
        path(fastq)
        val(sample_id)

    output:
        tuple (sample_id, fastq_id, path("${fastq_id}.sam"), emit: mapped_sams)

    script:
        readgroup = "\"@RG\\tID:${fastq.simpleName}\\tSM:${sample_id}\\tPL:ONT\\tLB:${sample_id}\""
        fastq_id = fastq.toString().replace('.fastq.gz', '')
        """
        minimap2 -t ${task.cpus} $params.optional -R $readgroup $params.genome_fasta $fastq > ${fastq_id}.sam
        """
}
