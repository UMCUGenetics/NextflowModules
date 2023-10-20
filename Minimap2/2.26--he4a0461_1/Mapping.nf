process Mapping {
    tag {"Minimap2 ${fastq.simpleName}"}
    label 'Minimap_2_26'
    container = 'quay.io/biocontainers/minimap2:2.26--he4a0461_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        path(fastq)

    output:
        tuple (val(fastq.simpleName), path("${fastq.simpleName}.sam"), emit: mapped_sams)

    script:
        def fastq_id = fastq.simpleName
        def rg_id = "\"@RG\\tID:$fastq_id\\tSM:$fastq_id\\tPL:ONT\\tLB:$fastq_id\""
        """
        minimap2 -t ${task.cpus} $params.optional -R $rg_id $params.genome_fasta $fastq > ${fastq_id}.sam
        """
}
