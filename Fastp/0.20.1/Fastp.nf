process Fastp {
    tag {"Fastp ${sample_id} - ${rg_id}"}
    label 'Fastp_0_20_1'
    container = 'quay.io/biocontainers/fastp:0.20.1--h8b12597_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, rg_id, path(fastqs)

    output:
    tuple sample_id, rg_id, "*.fastq.gz", emit: fastqs_cleaned
    path "${sample_id}_fastp.json", emit: fastp_report

    script:
    //adapted from https://github.com/nf-core/eager/blob/master/LICENSE, Copyright (c) Alexander Peltzer, Stephen Clayton, James A. Fellows Yates, Maxime Borry
    if (params.singleEnd) {
        """
        fastp --in1 ${fastqs[0]} --out1 "${fastqs[0].simpleName}_trim.fastq.gz" -j ${sample_id}_fastp.json ${params.optional}
        """
    } else {
        """
        fastp --in1 ${fastqs[0]} --in2 ${fastqs[1]} --out1 "${fastqs[0].simpleName}_trim.fastq.gz" --out2 "${fastqs[1].simpleName}_trim.fastq.gz" -j ${sample_id}_fastp.json ${params.optional}
        """
   }
}
