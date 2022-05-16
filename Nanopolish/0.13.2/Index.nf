process NanopolishIndex {
    tag {"NanopolishIndex ${sample_id} - ${fastq_id}"}
    label 'NanopolishIndex_0_13_2'
    container = 'quay.io/biocontainers/nanopolish:0.13.2--h92fde30_9'
    shell = ['/bin/bash', '-euo', 'pipefail']
    
    input:
        tuple(path(fastq), fastq_id, sample_id, run_id)        

    output:
        tuple (path(fastq), fastq_id, sample_id, run_id, path("${fastq}.index"), path("${fastq}.index.fai"),  path("${fastq}.index.gzi"), path("${fastq}.index.readdb"))

    script:
        def fast5_path = params.fast5_path
        // ADD sequence summary to maken it waaay faster!
        """
        nanopolish index -d $fast5_path $fastq  
        """
}
