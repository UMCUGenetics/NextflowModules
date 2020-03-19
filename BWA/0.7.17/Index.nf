
process Index {
    tag {"BWA Index $fasta"}
    label 'BWA_0_7_17'
    label 'BWA_0_7_17_Index'
    container = 'container_url'
    shell = ['/bin/bash', '-euo', 'pipefail']

    storeDir index_dir

    input:
    file(fasta)

    output:
    file("${fasta}.*")


    script:
    index_dir = file(fasta).getParent().toRealPath().toString()

    """
    bwa index $params.optional $fasta
    """

}
