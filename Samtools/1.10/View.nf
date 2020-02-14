process View {
    // samtools mpileup can produce multiple output types, this process creates pileup files.
    tag {"Samtools View ${sample_id}"}
    label 'Samtools_1_10'
    label 'Samtools_1_10_View'
    container = 'quay.io/biocontainers/samtools:1.10--h9402c20_2'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, file(bam_file), file(bai_file)

    output:
    tuple sample_id, file("${bam_file.baseName}.sam")

    script:
    """
    samtools view ${params.samtools.view.optional} $bam_file ${params.samtools.view.region} > ${bam_file.baseName}.sam
    """
}
