process SortMeRna {
    tag {"SortMeRNA sortmerna ${db_fasta.baseName}"}
    label 'SortMeRNA_4_2_0'
    container = 'quay.io/biocontainers/sortmerna:4.2.0--0'
    shell = ['/bin/bash', '-euo', 'pipefail']
    
    input:
    tuple sample_id, rg_id, file(reads)
    file(db_fasta) 
   
    
    output:
    tuple sample_id, rg_id, file("*.fastq.gz") 
    file("*_rRNA_report.txt")
    
    script:
    def Refs =  db_fasta.collect{ "$it" }.join("-ref") 

    if (params.singleEnd) {
        """
        sortmerna ${Refs} \
            -reads ${reads} \
            --num_alignments 1 \
            --threads ${task.cpus} \
            --fastx \
            -workdir \${PWD} \
            --aligned rRNA-reads \
            --other non-rRNA-reads 
        gzip -f < non-rRNA-reads.fastq > ${sample_id}.fastq.gz
        mv rRNA-reads.log ${sample_id}_rRNA_report.txt
        """
    } else {
        """
        sortmerna --ref ${Refs} \
            -reads ${reads[0]} -reads ${reads[1]} \
            --num_alignments 1 \
            --threads ${task.cpus} \
            -workdir \${PWD} \
            --fastx -paired_in \
            --aligned rRNA-reads \
            --other non-rRNA-reads \
            -out2
        gzip < non-rRNA-reads_fwd.fastq > ${sample_id}-fwd.fastq.gz
        gzip < non-rRNA-reads_rev.fastq> ${sample_id}-rev.fastq.gz
        mv rRNA-reads.log ${sample_id}_rRNA_report.txt
        """
    }
}
