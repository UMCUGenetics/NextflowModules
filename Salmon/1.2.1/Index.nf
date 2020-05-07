process Index {
    tag {"Salmon Index ${transcripts_fasta.baseName}"}
    label 'Salmon_1_2_1'
    label 'Salmon_1_2_1_Index'
    container = 'quay.io/biocontainers/salmon:1.2.1--hf69c8f4_0'
    shell = ['/bin/bash', '-euo', 'pipefail']
    
    input:
    file(transcripts_fasta)
    
   
    output:
    file("${transcripts_fasta.baseName}/")

    script:
    def gencode = params.gencode  ? "--gencode" : ""
    """
    salmon index --threads ${task.cpus} -t ${transcripts_fasta} ${params.optional} ${gencode} -i ${transcripts_fasta.baseName}       
    """
}

