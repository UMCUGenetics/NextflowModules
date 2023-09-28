process MPileup {
    // samtools mpileup can produce multiple output types, this process creates pileup files.
    tag {"Samtools MPileup ${sample_id}"}
    label 'Samtools_1_16_1'
    label 'Samtools_1_16_1_MPileup'
    container = 'quay.io/biocontainers/samtools:1.16.1--h6899075_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam_file), path(bai_file))

    output:
        tuple(val(sample_id), path("${bam_file.baseName}.pileup"), emit: pileup)

    script:
        """
        samtools mpileup ${params.optional} -f ${params.genome} ${bam_file} > ${bam_file.baseName}.pileup
        """
}

process MPileup_bcf {
    // samtools mpileup can produce multiple output types, this process creates bcf files.
    tag {"Samtools MPileup_bcf ${sample_id}"}
    label 'Samtools_1_16_1'
    label 'Samtools_1_16_1_MPileup_bcf'
    container = 'quay.io/biocontainers/samtools:1.16.1--h6899075_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam_file), path(bai_file))

    output:
        tuple(val(sample_id), path("${bam_file.baseName}.bcf"), emit: bcf)

    script:
        """
        samtools mpileup ${params.optional} -u -f ${params.genome} ${bam_file} > ${bam_file.baseName}.bcf
        """
}
