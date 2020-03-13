process FilterConsensusReads {
    tag {"FGBIO_filterconsensusreads ${sample_id}"}
    label 'FGBIO_1_1_0'
    label 'FGBIO_filterconsensusreads_1_1_0'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.filterconsensusreads.mem}" : ""

    // container = 'library://sawibo/default/bioinf-tools:gatk4.1.3.0'

    input:
      tuple sample_id, file(bam)

    output:
      tuple sample_id, file("${sample_id}.u.consensus.filtered.bam")

    script:
    fgbio_path = '/hpc/local/CentOS7/cog_bioinf/fgbio-1.1.0/fgbio-1.1.0.jar'

    """
    java -Xmx${task.memory.toGiga()-4}g -jar $fgbio_path --tmp-dir \$PWD FilterConsensusReads \
    --input $bam \
    --output ${sample_id}.u.consensus.filtered.bam \
    --ref $params.genome_fasta \
    ${params.filterconsensusreads.toolOptions}
    """
}
