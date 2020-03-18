process FilterConsensusReads {
    tag {"FGBIO_filterconsensusreads ${sample_id}"}
    label 'FGBIO_1_1_0'
    label 'FGBIO_1_1_0_filterconsensusreads'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.filterconsensusreads.mem}" : ""


    input:
      tuple sample_id, file(bam)

    output:
      tuple sample_id, file("${sample_id}.u.consensus.filtered.bam")

    script:

    """
    java -Xmx${task.memory.toGiga()-4}g -jar ${params.fgbio_path} --tmp-dir \$PWD FilterConsensusReads \
    --input $bam \
    --output ${sample_id}.u.consensus.filtered.bam \
    --ref $params.genome_fasta \
    ${params.filterconsensusreads.toolOptions}
    """
}
