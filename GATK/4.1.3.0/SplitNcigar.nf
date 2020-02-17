
process SplitNcigar {
    tag {"GATK_splitncigar ${sample_id}"}
    label 'GATK_4_1_3_0'
    label 'GATK_splitncigar_4_1_3_0'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.splitncigar.mem}" : ""

    input:
      tuple sample_id, file(bam), file(bai)
      file(genome_fasta)
      file(genome_index)
      file(genome_dict)

    output:
      tuple sample_id, file("${sample_id}.split.bam"), file("${sample_id}.split.bam.bai"),  

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
