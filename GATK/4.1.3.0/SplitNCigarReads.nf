
process SplitNCigarReads {
    tag {"GATK SplitNCigarReads ${sample_id}"}
    label 'GATK_4_1_3_0'
    label 'GATK_4_1_3_0_SplitNCigarReads'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.splitncigarreads.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:gatk4.1.3.0'
    
    input:
      tuple sample_id, file(bam), file(bai)
   
    output:
      tuple sample_id, file("${sample_id}.split.bam"), file("${sample_id}.split.bai")

    script:
    """
    gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
    SplitNCigarReads \
    -R $params.genome_fasta \
    -I $bam \
    --refactor-cigar-string \
    -O ${sample_id}.split.bam
    """
}
