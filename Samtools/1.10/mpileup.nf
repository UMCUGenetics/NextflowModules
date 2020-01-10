process Mpileup {
    tag {"Samtools mpileup ${sample_id}"}
    label 'Samtools_1_10'
    label 'Samtools_1_10_mpileup'
    container = 'quay.io/biocontainers/samtools:1.10--h9402c20_2'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, file(bam_file), file(bai_file)

    output:
    tuple sample_id, file(mpileup_file)

    script:
    """
    samtools mpileup $params.samtools.mpileup.optional -f $params.samtools.mpileup.genome $bam_file > ${bam_file.baseName}.mpileup
    """
}
