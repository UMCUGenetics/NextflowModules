process Zip_Index {
    tag {"Tabix_Zip_Index ${sample_id}"}
    label 'Tabix_Zip_Index'
    label 'Tabix_Zip_Index_1_1'
    container = 'quay.io/biocontainers/tabix:1.11--hdfd78af_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(vcf_file), val(ploidy))

    output:
        tuple(val(sample_id), path("${vcf_file}.gz"), path("${vcf_file}.gz.tbi"), val(ploidy))

    script:
        """
        bgzip $vcf_file
        tabix ${vcf_file}.gz
        """
}
