process CreateSequenceDictionary  {
    tag {"PICARD CreateSequenceDictionary"}
    label 'PICARD_2_25_5'
    label 'PICARD_2_25_5_CreateSequenceDictionary'
    container = 'uay.io/biocontainers/picard:2.25.5--hdfd78af_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        path(genome_fasta)

    output:
        path("${genome_fasta.baseName}.dict", emit: genome_dict)

    script:
        """
        picard -Xmx${task.memory.toGiga()-4}G CreateSequenceDictionary REFERENCE=${genome_fasta} OUTPUT=${genome_fasta.baseName}.dict ${params.optional}
        """
}
