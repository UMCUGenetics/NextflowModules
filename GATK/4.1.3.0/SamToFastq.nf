
process SamToFastq {
    tag {"GATK SamToFastq ${sample_id} "}
    label 'GATK_4_1_3_0'
    label 'GATK_4_1_3_0_SamToFastq'

    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:gatk4.1.3.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple (sample_id, flowcell, machine, run_nr, path(bam))

    output:
        tuple (sample_id, flowcell, machine, run_nr, path("*.fastq.gz"), emit: converted_fastqs)

    script:
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
        SamToFastq  \
        ${params.optional} \
        --INPUT $bam \
        --FASTQ ${sample_id}_${flowcell}_R1_001.fastq.gz \
        --SECOND_END_FASTQ ${sample_id}_${flowcell}_R2_001.fastq.gz \
        --INCLUDE_NON_PF_READS true \
        """
}
