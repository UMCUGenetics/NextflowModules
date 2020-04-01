process CallMolecularConsensusReads {
    tag {"FGBIO Callmolecularconsensusreads ${sample_id}"}
    label 'FGBIO_1_1_0'
    label 'FGBIO_1_1_0_Callmolecularconsensusreads'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.callmolecularconsensusreads.mem}" : ""

    input:
      tuple sample_id, flowcell, machine, run_nr, file(bam)

    output:
      tuple sample_id, flowcell, machine, run_nr, file("${sample_id}.u.consensus.bam")

    script:
    // machine = 'NB501403'
    // run_nr = 183
    """
    java -Xmx${task.memory.toGiga()-4}g -jar ${params.fgbio_path} --tmp-dir \$PWD CallMolecularConsensusReads \
    --input $bam \
    --output ${sample_id}.u.consensus.bam \
    ${params.callmolecularconsensusreads.toolOptions} \
    --read-group-id "${sample_id}_${flowcell}" \
    --read-name-prefix "${machine}:${run_nr}:${flowcell}:0:0:0:0"
    """
}
    // --read-name-prefix "${sample_id}${flowcell}"
