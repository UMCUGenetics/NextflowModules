
process SplitNCigarReads {
    tag {"GATK SplitNCigarReads ${sample_id}"}
    label 'GATK_4_1_3_0'
    label 'GATK_4_1_3_0_SplitNCigarReads'
    container = 'library://sawibo/default/bioinf-tools:gatk4.1.3.0'
    
    input:
      tuple(sample_id, path(bam), path(bai))
   
    output:  
      tuple(sample_id, path("${sample_id}.split.bam"), path("${sample_id}.split.bai"), emit: bam_ncigar_split)

    script:
    """
    gatk --java-options "-Xmx${task.memory.toGiga()-4}g" \
    SplitNCigarReads --tmp-dir \$PWD \
    -R ${params.genome_fasta} \
    -I ${bam} \
    --refactor-cigar-string \
    -O ${sample_id}.split.bam
    """
}
