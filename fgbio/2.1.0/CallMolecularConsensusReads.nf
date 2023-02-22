process CallMolecularConsensusReads {
    tag {"FGBIO CallMolecularConsensusReads ${sample_id}"}
    label 'FGBIO_2_1_0'
    label 'FGBIO_2_1_0_CallMolecularConsensusReads'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    // container = 'library://sawibo/default/bioinf-tools:idt-umi-dependencies'

    shell = ['/bin/bash', '-euo', 'pipefail']
    input:
      tuple (sample_id, flowcell, machine, run_nr, path(bam))

    output:
      tuple (sample_id, flowcell, machine, run_nr, path("${sample_id}.consensus.bam"), emit : consensus_bams)

    script:
    fgbio_exec = params.fgbio_exec
    """
    java -Xmx${task.memory.toGiga()-4}g -jar ${fgbio_exec} --tmp-dir \$PWD --compression 1 CallMolecularConsensusReads \
    --input $bam \
    --output ${sample_id}.consensus.bam \
    --threads ${task.cpus} \
    ${params.optional}





    """
}
// --read-group-id "${sample_id}_${flowcell}" \
// --read-name-prefix "${machine}:${run_nr}:${flowcell}:0:0:0:0"
