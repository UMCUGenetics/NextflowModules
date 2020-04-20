process SortMeRNA {
    tag {"SortMeRNA sortmerna ${fasta.baseName}"}
    label 'SortMeRNA_4_2_0'
    label 'SortMeRNA_4_2_0_sortmerna'
    container = 'quay.io/biocontainers/sortmerna:4.2.0--0'
    shell = ['/bin/bash', '-euo', 'pipefail']
    
    input:
    tuple sample_id, file(reads)
    val(db_name)
    file(db_fasta) 
    file(db) 
    
    output:
    tuple sample_id, file("*.fq.gz"), emit: sortmerna_fastqs 
    file("*_rRNA_report.txt"), emit: sortmerna_report
    
    script:
    //concatenate reference files: ${db_fasta},${db_name}:${db_fasta},${db_name}:...
        def Refs = ''
        for (i=0; i<db_fasta.size(); i++) { Refs+= ":${db_fasta[i]},${db_name[i]}" }
        Refs = Refs.substring(1)
        if (params.singleEnd) {
            """
            gzip -d --force < ${reads} > all-reads.fastq
            sortmerna --ref ${Refs} \
                --reads all-reads.fastq \
                --num_alignments 1 \
                -a ${task.cpus} \
                --fastx \
                --aligned rRNA-reads \
                --other non-rRNA-reads \
                --log -v
            gzip --force < non-rRNA-reads.fastq > ${name}.fq.gz
            mv rRNA-reads.log ${name}_rRNA_report.txt
            """
        } else {
            """
            gzip -d --force < ${reads[0]} > reads-fw.fq
            gzip -d --force < ${reads[1]} > reads-rv.fq
            merge-paired-reads.sh reads-fw.fq reads-rv.fq all-reads.fastq
            sortmerna --ref ${Refs} \
                --reads all-reads.fastq \
                --num_alignments 1 \
                -a ${task.cpus} \
                --fastx --paired_in \
                --aligned rRNA-reads \
                --other non-rRNA-reads \
                --log -v
            unmerge-paired-reads.sh non-rRNA-reads.fastq non-rRNA-reads-fw.fq non-rRNA-reads-rv.fq
            gzip < non-rRNA-reads-fw.fq > ${name}-fw.fq.gz
            gzip < non-rRNA-reads-rv.fq > ${name}-rv.fq.gz
            mv rRNA-reads.log ${name}_rRNA_report.txt
            """
}

