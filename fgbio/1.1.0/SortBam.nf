process SortBam {
    tag {"FGBIO_sortbam ${sample_id}"}
    label 'FGBIO_1_1_0'
    label 'FGBIO_1_1_0_sortbam'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.sortbam.mem}" : ""

    input:
      tuple sample_id, file(bam)

    output:
      tuple sample_id, file("${sample_id}.u.grouped.sorted.bam")

    script:

    """
    java -Xmx${task.memory.toGiga()-4}g -jar ${params.fgbio_path} --tmp-dir \$PWD SortBam \
    --input $bam \
    --output ${sample_id}.u.grouped.sorted.bam \
    ${params.sortbam.toolOptions}
    """
}
