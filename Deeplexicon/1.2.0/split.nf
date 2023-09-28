process split {
    tag {"Deeplexicon_split"}
    label 'Deeplexicon_1_2_0'
    label 'Deeplexicon_1_2_0_split'
    container = 'lpryszcz/deeplexicon:1.2.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(id), path(tsv),path(fastq))
        
    output:
        path("*.fastq.gz")

    script:
        """
        deeplexicon_multi.py split \
            -i ${tsv} \
            -o . \
            -s ${id} \
            -q ${fastq}

        #deeplexicon outputs plain fastq, so gzip them
        gzip ${id}_bc_*.fastq
        """
}