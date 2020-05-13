process TrimGalore {
    tag {"TrimGalore ${sample_id} - ${rg_id}"}
    label 'TrimGalore_0_6_5'
    container = 'quay.io/biocontainers/trim-galore:0.6.5--0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
      tuple(sample_id, rg_id, path(fastqs)) 

    output:
      tuple(sample_id, rg_id, path("*fastq.gz"), emit: trimmed_fastqs) 
      path("*trimming_report.txt", emit: trimming_report)
      path("*_fastqc.{zip,html}", emit: trimming_fastqc) 

    script:
    if (params.singleEnd) {
        """
        trim_galore ${fastqs} --gzip ${params.optional}
        mv ${fastqs[0].simpleName}_trimmed.fq.gz ${fastqs[0].simpleName}_trimmed.fastq.gz 
        """
    } else {
        """
        trim_galore ${fastqs} --paired --gzip ${params.optional}
        mv ${fastqs[0].simpleName}_val_1.fq.gz ${fastqs[0].simpleName}_trimmed.fastq.gz 
        mv ${fastqs[1].simpleName}_val_2.fq.gz ${fastqs[1].simpleName}_trimmed.fastq.gz 
        """
    }
}
