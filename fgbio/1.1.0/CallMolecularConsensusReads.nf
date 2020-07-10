process CallMolecularConsensusReads {
    tag {"FGBIO CallMolecularConsensusReads ${sample_id}"}
    label 'FGBIO_1_1_0'
    label 'FGBIO_1_1_0_CallMolecularConsensusReads'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:idt-umi-dependencies'
    shell = ['/bin/bash', '-euo', 'pipefail']
    input:
        tuple (sample_id, flowcell, machine, run_nr, path(bam))

    output:
        tuple (sample_id, flowcell, machine, run_nr, path("${sample_id}.u.consensus.bam"), emit : consensus_bams)

    script:
        """
        java -Xmx${task.memory.toGiga()-4}g -jar /bin/fgbio-1.1.0.jar --tmp-dir \$PWD CallMolecularConsensusReads \
        --input $bam \
        --output ${sample_id}.u.consensus.bam \
        ${params.optional} \
        --read-group-id "${sample_id}_${flowcell}" \
        --read-name-prefix "${machine}:${run_nr}:${flowcell}:0:0:0:0"
        """
}
