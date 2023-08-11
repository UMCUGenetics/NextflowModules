process Faidx {
    tag {"Samtools Faidx ${fasta}"}
    label 'Samtools_1_10'
    label 'Samtools_1_10_Faidx'
    container = 'quay.io/biocontainers/samtools:1.10--h9402c20_2'
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
