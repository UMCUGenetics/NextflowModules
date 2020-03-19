process DemuxFastqs {
    tag {"FGBIO_demuxfastqs "}
    label 'FGBIO_1_1_0'
    label 'FGBIO_1_1_0_demuxfastqs'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.demuxfastqs.mem}" : ""

    input:
      tuple sample_sheet, file(fastq: "*"), read_structures

    output:
      tuple file("metrics.txt"), file("*.fastq.gz")

    script:

    """
    java -Xmx${task.memory.toGiga()-4}g -jar ${params.fgbio_path} --tmp-dir $TMPDIR DemuxFastqs \
    --input $fastq \
    --read-structures $read_structures \
    --metadata $sample_sheet \
    --output \$PWD \
    ${params.demuxfastqs.toolOptions}
    """
}
