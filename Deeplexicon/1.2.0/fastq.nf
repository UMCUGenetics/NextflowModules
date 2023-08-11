process deeplexicon_concatFastq {
    tag {"Deeplexicon_concat_fastq"}
    label 'Deeplexicon_1_2_0'
    label 'Deeplexicon_1_2_0_concat_fastq'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(id), val(chunk), path(fastq))

    output:
	tuple(val(id), path("${id}_combined.fastq"), emit:fastq)

    script:
        """
        cat *.fastq.gz > ${id}_combined.fastq.gz
        gunzip ${id}_combined.fastq.gz
        """
}