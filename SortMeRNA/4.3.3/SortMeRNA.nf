process SortMeRNA {
    tag {"SortMeRNA ${sample_id}"}
    label 'SortMeRNA_4_3_3'
    container = 'quay.io/biocontainers/sortmerna:4.3.3--h9ee0642_0'
    shell = ['/bin/bash', '-euo', 'pipefail']
    
    input:
        tuple(sample_id, rg_id, path(fastq_files))
        path(db_fasta) 
    
    output:
        tuple(sample_id, rg_id, path("*_non_rRNA.fastq.gz"), emit: non_rRNA_fastqs)
        path("*_filtered_rRNA.fastq.gz", emit: rRNA_fastqs)
        path("*_rRNA_report.txt", emit: qc_report)
    
    script:
        def refs =  db_fasta.collect{ "$it" }.join(" -ref ")
        def report_title = fastq_files[0].simpleName.split("_R1_")[0]  
        if (params.single_end) {
            """
            sortmerna -ref ${refs} \
                -reads ${fastq_files} \
                --num_alignments 1 \
                --threads ${task.cpus} \
                --fastx \
                -workdir \${PWD} \
                --aligned rRNA-reads \
                --other non-rRNA-reads  \
                --zip-out
 
            mv non-rRNA-reads.fq.gz ${fastq_files[0].simpleName}_non_rRNA.fastq.gz
            mv rRNA-reads.fq.gz ${fastq_files[0].simpleName}_filtered_rRNA.fastq.gz
            mv rRNA-reads.log ${report_title}_rRNA_report.txt
            """
        } else {
            """
            sortmerna -ref ${refs} \
                -reads ${fastq_files[0]} -reads ${fastq_files[1]} \
                --num_alignments 1 \
                --threads ${task.cpus} \
                -workdir \${PWD} \
                --fastx -paired_in \
                --aligned rRNA-reads \
                --other non-rRNA-reads \
                -out2 \
                --zip-out

            mv non-rRNA-reads_fwd.fq.gz  ${fastq_files[0].simpleName}_non_rRNA.fastq.gz
            mv non-rRNA-reads_rev.fq.gz  ${fastq_files[1].simpleName}_non_rRNA.fastq.gz
            mv rRNA-reads_fwd.fq.gz  ${fastq_files[0].simpleName}_filtered_rRNA.fastq.gz
            mv rRNA-reads_rev.fq.gz  ${fastq_files[1].simpleName}_filtered_rRNA.fastq.gz            
            mv rRNA-reads.log ${report_title}_rRNA_report.txt
            """
        }
}
