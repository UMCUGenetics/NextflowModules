process TrimGalore {
    tag {"TrimGalore ${sample_id} - ${rg_id}"}
    label 'TrimGalore_0_6_5'
    container = 'quay.io/biocontainers/trim-galore:0.6.5--0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, rg_id, path(fastq_files)) 

    output:
        tuple(sample_id, rg_id, path("*fastq.gz"), emit: fastqs_trimmed) 
        path("*trimming_report.txt", emit: trimming_report)
        path("*_fastqc.{zip,html}", optional: true, emit: fastqc_report) 

    script:
        if (params.singleEnd) {
            """
            trim_galore ${fastq_files} --gzip ${params.optional}
            mv ${fastq_files[0].simpleName}_trimmed.fq.gz ${fastq_files[0].simpleName}_trimmed.fastq.gz 
            """
        } else {
            """
            trim_galore ${fastq_files} --paired --gzip ${params.optional}
            mv ${fastq_files[0].simpleName}_val_1.fq.gz ${fastq_files[0].simpleName}_trimmed.fastq.gz 
            mv ${fastq_files[1].simpleName}_val_2.fq.gz ${fastq_files[1].simpleName}_trimmed.fastq.gz 
            """
        }
}
