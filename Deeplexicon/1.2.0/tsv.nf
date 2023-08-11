process deeplexicon_copyTsv {
    tag {"deeplexicon_copyTsv"}
    label 'deeplexicon_copyTsv'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample), val(chunk), path(tsv))

    output:
        tuple(val(sample), val(chunk), path("${sample}_${chunk}_copy_${tsv}"), emit:tsv)

    script:
        """
        echo \"Copy tsv: ${tsv}\"
        cp ${tsv} ${sample}_${chunk}_copy_${tsv}
        """
}

process deeplexicon_concatTsv {
    tag {"Deeplexicon_concat_tsv"}
    label 'Deeplexicon_1_2_0'
    label 'Deeplexicon_1_2_0_concat_tsv'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(id), val(chunk), path(tsv))

    output:
        tuple(val(id), path("${id}_combined.tsv"), emit:tsv)

    script:
        """
        print_header=1
        echo \"Test concatTsv sample: ${id}\"
        for tsv_chunk in ./*.tsv; do       
            #print header
            if [[ \${print_header} -eq 1 ]]; then
                head -n1 \${tsv_chunk} > ${id}_combined.tsv
                print_header=0
            fi
            #print content
            tail -n+2 \${tsv_chunk} >> ${id}_combined.tsv
        done
        """
}