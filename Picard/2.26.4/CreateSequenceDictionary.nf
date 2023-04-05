process CreateSequenceDictionary  {
    tag {"PICARD CreateSequenceDictionary"}
    label 'PICARD_2_26_4'
    label 'PICARD_2_26_4_CreateSequenceDictionary'
    container = 'quay.io/biocontainers/picard:2.26.4--hdfd78af_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        path(genome_fasta)

    output:
        path("${genome_fasta.baseName}.dict", emit: genome_dict)

    script:
        """
        picard -Xmx${task.memory.toGiga()-4}G CreateSequenceDictionary REFERENCE=${genome_fasta} OUTPUT=${genome_fasta.baseName}.dict
        """
}
