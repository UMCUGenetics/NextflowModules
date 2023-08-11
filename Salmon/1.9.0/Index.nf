process Index {
    tag {"Salmon Index ${transcripts_fasta.baseName}"}
    label 'Salmon_1_9_0'
    label 'Salmon_1_9_0_Index'
    container = 'quay.io/biocontainers/salmon:1.9.0--h7e5ed60_1'
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

