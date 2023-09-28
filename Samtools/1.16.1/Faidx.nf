process Faidx {
    tag {"Samtools Faidx ${fasta}"}
    label 'Samtools_1_16_1'
    label 'Samtools_1_16_1_Faidx'
    container = 'quay.io/biocontainers/samtools:1.16.1--h6899075_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        path(fasta)

    output:
        path("${fasta.name}.fai", emit: genome_faidx)

    script:
        """
        samtools faidx ${fasta}
        """
}
