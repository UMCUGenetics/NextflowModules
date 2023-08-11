process dmux {
    tag {"Deeplexicon_dmux"}
    label 'Deeplexicon_1_2_0'
    label 'Deeplexicon_1_2_0_dmux'
    container = 'lpryszcz/deeplexicon:1.2.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample), val(chunk), path(fast5))

    output:
        tuple(val(sample), val(chunk), path("${sample}_${chunk}.demux2.tsv"), emit:tsv)

    script:
        """
        #deeplexicon only works when folder is passed, not when fast5 itself is used so put file in folder for further processing
        mkdir fast5_folder
        cp -P ${fast5} fast5_folder/
        deeplexicon_multi.py dmux \
	    --threads 2 \
            -p ./fast5_folder/ \
            -m /deeplexicon/models/resnet20-final.h5 \
        > ${sample}_${chunk}.demux2.tsv
        """
}
