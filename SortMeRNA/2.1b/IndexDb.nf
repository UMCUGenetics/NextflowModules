process IndexDb {
    tag {"SortMeRNA IndexDb ${fasta.baseName}"}
    label 'SortMeRNA_4_2_0'
    label 'SortMeRNA_4_2_0_IndexDb'
    container = 'quay.io/biocontainers/sortmerna:4.2.0--0'
    shell = ['/bin/bash', '-euo', 'pipefail']
    
    input:
    file(fasta)
    
    output:
    val("${fasta.baseName}"), emit: sortmerna_db_name
    file("${fasta}"), emit: sortmerna_db_fasta
    file("${fasta.baseName}*"), emit: sortmerna_db

    script:
    """
    indexdb_rna --ref ${fasta},${fasta.baseName} -m 3072 -v
    """
}

