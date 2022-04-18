process Megalodon {
    tag {"Megalodon ${sample_id} - ${fastq_id}"}
    label 'Megalodon_2_4_1'
    container = 'quay.io/biocontainers/megalodon:2.4.1--py36h91eb985_1'
    shell = ['/bin/bash', '-euo', 'pipefail']
    
    input:
        tuple(path(fastq), fastq_id, sample_id, run_id)        

    output:
        tuple (path(fastq), fastq_id, sample_id, run_id, path("${fastq}.index"), path("${fastq}.index.fai"),  path("${fastq}.index.gzi"), path("${fastq}.index.readdb"))

    script:
        fast5_path = params.fast5_path
        """
        nanopolish index -d $fast5_path $fastq  
        """
}
