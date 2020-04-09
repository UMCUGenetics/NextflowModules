process DemuxFastqs {
    tag {"FGBIO DemuxFastqs "}
    label 'FGBIO_1_1_0'
    label 'FGBIO_1_1_0_DemuxFastqs'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.demuxfastqs.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:idt-umi-dependencies'
    input:
      tuple sample_sheet, flowcell, file(fastq: "*"), read_structures

    output:
      tuple file("metrics.txt"),flowcell, file("*.fastq.gz")

    script:

    """
    java -Xmx${task.memory.toGiga()-4}g -jar /bin/fgbio-1.1.0.jar --tmp-dir \$TMPDIR DemuxFastqs \
    --input $fastq \
    --read-structures $read_structures \
    --metadata $sample_sheet \
    --output \$PWD \
    ${params.demuxfastqs.toolOptions}
    """
}
