process CallMolecularConsensusReads {
    tag {"FGBIO Callmolecularconsensusreads ${sample_id}"}
    label 'FGBIO_1_1_0'
    label 'FGBIO_1_1_0_Callmolecularconsensusreads'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.callmolecularconsensusreads.mem}" : ""
    // container = '/hpc/cog_bioinf/cuppen/personal_data/sander/scripts/Nextflow/Singularity-images/idt-umi-dependencies.squashfs'
    container = 'library://sawibo/default/bioinf-tools:idt-umi-dependencies'
    input:
      tuple sample_id, flowcell, machine, run_nr, file(bam)

    output:
      tuple sample_id, flowcell, machine, run_nr, file("${sample_id}.u.consensus.bam")

    script:
    // machine = 'NB501403'
    // run_nr = 183
    """
    java -Xmx${task.memory.toGiga()-4}g -jar /bin/fgbio-1.1.0.jar --tmp-dir \$PWD CallMolecularConsensusReads \
    --input $bam \
    --output ${sample_id}.u.consensus.bam \
    ${params.callmolecularconsensusreads.toolOptions} \
    --read-group-id "${sample_id}_${flowcell}" \
    --read-name-prefix "${machine}:${run_nr}:${flowcell}:0:0:0:0"
    """
}
    // --read-name-prefix "${sample_id}${flowcell}"
