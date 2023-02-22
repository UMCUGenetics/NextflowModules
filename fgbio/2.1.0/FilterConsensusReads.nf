process FilterConsensusReads {
    tag {"FGBIO FilterConsensusReads ${sample_id}"}
    label 'FGBIO_2_1_0'
    label 'FGBIO_2_1_0_FilterConsensusReads'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    fgbio_exec = $params.fgbio_exec
    shell = ['/bin/bash', '-euo', 'pipefail']
    input:
      tuple (sample_id, flowcell, machine, run_nr, path(bam))

    output:
      tuple (sample_id, flowcell, machine, run_nr, path("${sample_id}.u.consensus.filtered.bam"), emit: filtered_bams)

    script:

    """
    java -Xmx${task.memory.toGiga()-4}g -jar ${fgbio_exec} --tmp-dir \$PWD FilterConsensusReads \
    --input $bam \
    --output ${sample_id}.u.consensus.filtered.bam \
    --ref $params.genome_fasta \
    ${params.optional}
    """
}
