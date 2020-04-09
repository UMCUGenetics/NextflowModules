process FilterConsensusReads {
    tag {"FGBIO FilterConsensusReads ${sample_id}"}
    label 'FGBIO_1_1_0'
    label 'FGBIO_1_1_0_FilterConsensusReads'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.filterconsensusreads.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:idt-umi-dependencies'
    input:
      tuple sample_id, flowcell, machine, run_nr, file(bam)

    output:
      tuple sample_id, flowcell, machine, run_nr, file("${sample_id}.u.consensus.filtered.bam")

    script:

    """
    java -Xmx${task.memory.toGiga()-4}g -jar /bin/fgbio-1.1.0.jar --tmp-dir \$PWD FilterConsensusReads \
    --input $bam \
    --output ${sample_id}.u.consensus.filtered.bam \
    --ref $params.genome_fasta \
    ${params.filterconsensusreads.toolOptions}
    """
}
