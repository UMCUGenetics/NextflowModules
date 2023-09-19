process Haplotag {
    tag {"Whatshap_Phase Minimap2 ${bam_file}"}
    label 'Whatshap_1_7'
    label 'Whatshap_1_7_Haplotag'
    container = 'quay.io/biocontainers/whatshap:1.7--py310h30d9df9_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam_file), path(bai_file), ploidy, path(vcf_file), path(vcf_index))

    output:
        path("${bam_file.simpleName}_tagged${params.extention}.bam")

    script:
        """
        whatshap haplotag \
            $vcf_file \
            $bam_file \
            -o ${bam_file.simpleName}_tagged${params.extention}.bam \
            --reference  $params.genome \
            --ploidy $ploidy
        """
}
