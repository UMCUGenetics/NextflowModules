process Fastq {
    tag {"Samtools Fastq ${bam_file}"}
    label 'Samtools_1_15'
    label 'Samtools_1_15_Fastq'
    container = 'quay.io/biocontainers/samtools:1.15.1--h1170115_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(path(bam_file), path(bai_file))

    output:
        path("${bam_file.baseName}.fastq")

    script:
        """
        samtools view -b ${bam_file} ${params.roi} | samtools fastq ${params.tags} /dev/stdin > ${bam_file.baseName}.fastq
        """
}
