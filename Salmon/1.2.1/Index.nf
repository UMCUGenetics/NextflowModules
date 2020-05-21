process Index {
    tag {"Salmon Index ${transcripts_fasta.baseName}"}
    label 'Salmon_1_2_1'
    label 'Salmon_1_2_1_Index'
    container = 'quay.io/biocontainers/salmon:1.2.1--hf69c8f4_0'
    shell = ['/bin/bash', '-euo', 'pipefail']
    
    input:
        path(transcripts_fasta)
    
   
    output:
        path("${transcripts_fasta.baseName}/", emit: salmon_index)

    script:
        def gencode = params.gencode  ? "--gencode" : ""
        """
        salmon index --threads ${task.cpus} -t ${transcripts_fasta} ${params.optional} ${gencode} -i ${transcripts_fasta.baseName}       
        """
}

