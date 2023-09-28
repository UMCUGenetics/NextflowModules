index_loc = file("${params.genome_fasta}").toRealPath().toString().split("/")[0..-2].join("/")

process Index {
    tag {"BWA_MEM2 Index $fasta"}
    label 'BWA_MEM2_2_2_1'
    label 'BWA_MEM2_2_2_1_Index'
    container = 'library://blcdsdockerregistry/bwa-mem2_samtools-1.12:2.2.1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    storeDir = index_loc

    input:
        path(fasta)

    output:
        path("${fasta}.{alt,amb,ann,bwt,pac,sa}", emit: bwa_index)

    script:
        """
        bwa-mem2 index $params.optional $fasta
        """
}
