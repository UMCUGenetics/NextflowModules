process View {
    tag {"Samtools View ${sample_id}"}
    label 'Samtools_1_16_1'
    label 'Samtools_1_16_1_View'
    container = 'quay.io/biocontainers/samtools:1.16.1--h6899075_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam_file), path(bai_file))

    output:
        tuple(val(sample_id), path("${bam_file.baseName}.sam"), emit: sam_file)

    script:
        """
        samtools view ${params.optional} ${bam_file} ${params.region} > ${bam_file.baseName}.sam
        """
}
