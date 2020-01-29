process MPileup {
    // samtools mpileup can produce multiple output types, this process creates pileup files.
    tag {"Samtools MPileup ${sample_id}"}
    label 'Samtools_1_10'
    label 'Samtools_1_10_MPileup'
    container = 'quay.io/biocontainers/samtools:1.10--h9402c20_2'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, file(bam_file), file(bai_file)

    output:
    tuple sample_id, file("${bam_file.baseName}.pileup")

    script:
    """
    samtools mpileup $params.samtools.mpileup.optional -f $params.samtools.mpileup.genome $bam_file > ${bam_file.baseName}.pileup
    """
}

process MPileup_bcf {
    // samtools mpileup can produce multiple output types, this process creates bcf files.
    tag {"Samtools MPileup_bcf ${sample_id}"}
    label 'Samtools_1_10'
    label 'Samtools_1_10_MPileup_bcf'
    container = 'quay.io/biocontainers/samtools:1.10--h9402c20_2'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, file(bam_file), file(bai_file)

    output:
    tuple sample_id, file("${bam_file.baseName}.bcf")

    script:
    """
    samtools mpileup $params.samtools.mpileup.optional -u -f $params.samtools.mpileup.genome $bam_file > ${bam_file.baseName}.bcf
    """
}
