process DemuxFastqs {
    tag {"FGBIO_demuxfastqs "}
    label 'FGBIO_1_1_0'
    label 'FGBIO_demuxfastqs_1_1_0'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.demuxfastqs.mem}" : ""

    // container = 'library://sawibo/default/bioinf-tools:gatk4.1.3.0'

    input:
      tuple sample_sheet, file(fastq: "*"), read_structures

    output:
      tuple file("metrics.txt"), file("*.fastq.gz")

    script:
    fgbio_path = '/hpc/local/CentOS7/cog_bioinf/fgbio-1.1.0/fgbio-1.1.0.jar'

    """
    java -Xmx${task.memory.toGiga()-4}g -jar $fgbio_path --tmp-dir $TMPDIR DemuxFastqs \
    --input $fastq \
    --read-structures $read_structures \
    --metadata $sample_sheet \
    --output \$PWD \
    ${params.demuxfastqs.toolOptions}
    """
}
