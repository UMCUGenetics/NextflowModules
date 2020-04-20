
process SamToFastq {
    tag {"GATK_SamToFastq ${sample_id}.${int_tag}"}
    label 'GATK_4_1_3_0'
    label 'GATK_4_1_3_0_SamToFastq'

    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.samtofastq.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:gatk4.1.3.0'

    // publishDir params.out_dir, mode: 'copy'
    input:
      tuple sample_id, flowcell, machine, run_nr,file(bam)

    output:
      tuple sample_id, flowcell, machine, run_nr,file("*.fastq.gz")

    script:

    """
    gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
    SamToFastq  \
    ${params.samtofastq.toolOptions} \
    --INPUT $bam \
    --FASTQ ${sample_id}_${flowcell}_R1_001.fastq.gz \
    --SECOND_END_FASTQ ${sample_id}_${flowcell}_R2_001.fastq.gz \
    --INCLUDE_NON_PF_READS true \
    """
}
