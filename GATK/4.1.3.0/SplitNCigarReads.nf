
process SplitNCigarReads {
    tag {"GATK_splitncigar ${sample_id}"}
    label 'GATK_4_1_3_0'
    label 'GATK_splitncigarreads_4_1_3_0'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.splitncigarreads_mem}" : ""
    container = "/hpc/local/CentOS7/cog_bioinf/nextflow_containers/GATK/gatk4.1.3.0.squashfs"
    input:
      tuple sample_id, file(bam), file(bai)
      file(genome_fasta)
      file(genome_index)
      file(genome_dict)

    output:
      tuple sample_id, file("${sample_id}.split.bam"), file("${sample_id}.split.bai")  

    script:
    """
    gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
    SplitNCigarReads \
    -R $params.genome_fasta \
    -I $bam \
    --refactor-cigar-string \
    ${params.splitncigarreads.toolOptions} \
    -O ${sample_id}.split.bam
    """
}
