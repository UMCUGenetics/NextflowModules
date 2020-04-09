process SortBam {
    tag {"FGBIO SortBam ${sample_id}"}
    label 'FGBIO_1_1_0'
    label 'FGBIO_1_1_0_SortBam'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.sortbam.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:idt-umi-dependencies'
    input:
      tuple sample_id, flowcell, machine, run_nr,file(bam)

    output:
      tuple sample_id, flowcell, machine, run_nr,file("${sample_id}.u.grouped.sorted.bam")

    script:

    """
    java -Xmx${task.memory.toGiga()-4}g -jar /bin/fgbio-1.1.0.jar --tmp-dir \$PWD SortBam \
    --input $bam \
    --output ${sample_id}.u.grouped.sorted.bam \
    ${params.sortbam.toolOptions}
    """
}
