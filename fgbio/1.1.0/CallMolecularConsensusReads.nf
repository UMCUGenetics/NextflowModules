process CallMolecularConsensusReads {
    tag {"FGBIO_callmolecularconsensusreads ${sample_id}"}
    label 'FGBIO_1_1_0'
    label 'FGBIO_1_1_0_callmolecularconsensusreads'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.callmolecularconsensusreads.mem}" : ""

    input:
      tuple sample_id, file(bam)

    output:
      tuple sample_id, file("${sample_id}.u.consensus.bam")

    script:

    """
    java -Xmx${task.memory.toGiga()-4}g -jar ${params.fgbio_path} --tmp-dir \$PWD CallMolecularConsensusReads \
    --input $bam \
    --output ${sample_id}.u.consensus.bam \
    ${params.callmolecularconsensusreads.toolOptions}
    """
}
