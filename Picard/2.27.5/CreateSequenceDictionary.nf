process CreateSequenceDictionary  {
    tag {"PICARD CreateSequenceDictionary"}
    label 'PICARD_2_27_5'
    label 'PICARD_2_27_5_CreateSequenceDictionary'
    container = 'quay.io/biocontainers/picard:2.27.5--hdfd78af_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        path(genome_fasta)

    output:
        path("${genome_fasta.baseName}.dict", emit: genome_dict)

    script:
        """
        picard -Xmx${task.memory.toGiga()-4}G -Djava.io.tmpdir=\$TMPDIR CreateSequenceDictionary \
        REFERENCE=${genome_fasta} \
        OUTPUT=${genome_fasta.baseName}.dict
        """
}
