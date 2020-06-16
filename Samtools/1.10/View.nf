process View {
    tag {"Samtools View ${sample_id}"}
    label 'Samtools_1_10'
    label 'Samtools_1_10_View'
    container = 'quay.io/biocontainers/samtools:1.10--h9402c20_2'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(bam_file), path(bai_file))

    output:
        tuple(sample_id, path("${bam_file.baseName}.sam"), emit: sam_file)

    script:
        """
        samtools view ${params.optional} ${bam_file} ${params.region} > ${bam_file.baseName}.sam
        """
}
