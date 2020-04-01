process TrimGalore {
    tag {"TrimGalore ${sample_id} - ${rg_id}"}
    label 'TrimGalore_0_6_5'
    container = 'quay.io/biocontainers/trim-galore:0.6.5--0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, rg_id, file(fastqs)

    output:
    tuple sample_id, rg_id, file("*fq.gz"), file("*trimming_report.txt"), file( "*_fastqc.{zip,html}") 

    script:
    def paired = !params.singleEnd ? "--paired" :""   	
    """
    trim_galore ${fastqs} ${paired} ${params.optional} 
    """
}
