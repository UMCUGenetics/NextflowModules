process Mpileup_bcf {
    // samtools mpileup can produce multiple output types, this process creates bcf files.
    tag {"Samtools Mpileup_BCF ${sample_id}"}
    label 'Samtools_1_10'
    label 'Samtools_1_10_Mpileup_bcf'
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
