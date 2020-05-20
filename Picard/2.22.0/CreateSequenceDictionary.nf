process CreateSequenceDictionary  {
    tag {"PICARD CreateSequenceDictionary"}
    label 'PICARD_2_22_0'
    label 'PICARD_2_22_0_CreateSequenceDictionary'
    container = 'quay.io/biocontainers/picard:2.22.0--0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    file(genome_fasta)

    output:
    file("${genome_fasta.baseName}.dict")

    script:
    """
    picard -Xmx${task.memory.toGiga()-4}G CreateSequenceDictionary REFERENCE=${genome_fasta} OUTPUT=${genome_fasta.baseName}.dict  
    """
}
