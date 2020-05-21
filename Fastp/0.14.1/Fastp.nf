process Fastp {
    tag {"Fastp ${sample_id} - ${rg_id}"}
    label 'Fastp_0_14_1'
    container = 'quay.io/biocontainers/fastp:0.14.1--0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, rg_id, path(fastq_files))

    output:
        tuple(sample_id, rg_id, path("*.fastq.gz"), emit: fastqs_cleaned)
        path("${sample_id}_fastp.json", emit: qc_report)

    script:
        //adapted from https://github.com/nf-core/eager/blob/master/LICENSE, Copyright (c) Alexander Peltzer, Stephen Clayton, James A. Fellows Yates, Maxime Borry
        if (params.singleEnd) {
            """
            fastp --in1 ${fastq_files[0]} --out1 "${fastq_files[0].simpleName}.trim.fastq.gz" -j ${sample_id}_fastp.json ${params.optional}
            """
        } else {
            """
            fastp --in1 ${fastq_files[0]} --in2 ${fastq_files[1]} --out1 "${fastq_files[0].simpleName}.trim.fastq.gz" --out2 "${fastq_files[1].simpleName}.trim.fastq.gz" -j ${sample_id}_fastp.json ${params.optional}
            """
        }
}
