index_loc = file("${params.genome_fasta}").toRealPath().toString().split("/")[0..-2].join("/")

process Index {
    tag {"BWA Index $fasta"}
    label 'BWA_0_7_17'
    label 'BWA_0_7_17_Index'
    container = 'library://sawibo/default/bioinf-tools:bwa-0.7.17_samtools-1.9'
    shell = ['/bin/bash', '-euo', 'pipefail']

    storeDir = index_loc

    input:
        path(fasta)

    output:
        path("${fasta}.{alt,amb,ann,bwt,pac,sa}", emit: bwa_index)


    script:
        """
        bwa index $params.optional $fasta
        """
}
