process Tabix_Tabix {
    tag {"Tabix Tabix ${vcf.name}"}
    label 'Tabix_1_11'
    label 'Tabix_1_11_Tabix'
    container = 'quay.io/biocontainers/tabix:1.11--hdfd78af_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        path(vcf)

    output:
        tuple(path("${vcf).name}", path("${vcf.name}.tbi"), emit: vcf)        

    script:
        """
        tabix -p vcf ${vcf.name}
        """
}