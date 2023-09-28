process LCExtrap {
    tag {"Preseq LCExtrap ${sample_id} "}
    label 'Preseq_3_2_0'
    label 'Preseq_3_2_0_LCExtrap'
    container = "quay.io/biocontainers/preseq:3.2.0--h867801b_3"
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam_file), path(bai_file))

    output:
        tuple(val(sample_id), path("${bam_file.baseName}.ccurve.txt") , emit: ccurve_table)

    script:
        //Adapted code from: https://github.com/nf-core/rnaseq - MIT License - Copyright (c) Phil Ewels, Rickard Hammarén
        """
        preseq lc_extrap ${params.optional} ${bam_file} -o ${bam_file.baseName}.ccurve.txt
        """
}
