process Flagstat {
    tag {"Samtools Flagstat ${sample_id}"}
    label 'Samtools_1_16_1'
    label 'Samtools_1_16_1_Flagstat'
    container = 'quay.io/biocontainers/samtools:1.16.1--h6899075_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam_file), path(bai_file))

    output:
        path("${bam_file.baseName}.flagstat", emit: flagstat)

    script:
        """
        samtools flagstat ${bam_file} > ${bam_file.baseName}.flagstat
        """
}
