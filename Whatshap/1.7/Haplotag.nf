process Haplotag {
    tag {"Whatshap_Phase Minimap2 ${sample_id}"}
    label 'Whatshap_1_7'
    label 'Whatshap_1_7_Haplotag'
    container = 'quay.io/biocontainers/whatshap:1.7--py310h30d9df9_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(bam_file), path(bai_file), path(vcf_file), path(vcf_index), ploidy)

    output:
        val(sample_id)
        path("${sample_id}_tagged.bam")

    script:
        """
        whatshap haplotag \
            $vcf_file \
            $bam_file \
            -o ${sample_id}_tagged.bam \
            --reference  $params.genome \
            --ploidy $ploidy

        """
}
