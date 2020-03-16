process Flagstat {
    tag {"Samtools Flagstat ${sample_id}"}
    label 'Samtools_1_10'
    label 'Samtools_1_10_Flagstat'
    container = 'quay.io/biocontainers/samtools:1.10--h9402c20_2'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, file(bam_file), file(bai_file)

    output:
    tuple sample_id, file("${bam_file.baseName}.flagstat")

    script:
    """
    samtools flagstat $bam_file > ${bam_file.baseName}.flagstat
    """
}
