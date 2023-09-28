process Tabix_BgzipTabix {
    tag {"Tabix BgzipTabix ${vcf.name}"}
    label 'Tabix_1_11'
    label 'Tabix_1_11_BgzipTabix'
    container = 'quay.io/biocontainers/tabix:1.11--hdfd78af_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        path(vcf)

    output:
        tuple(path("${vcf.simpleName}.vcf.gz"), path("${vcf.simpleName}.vcf.gz.tbi"), emit: vcf)          
        //tuple(path("${vcf.name}.gz"), path("${vcf.name}.gz.tbi"), emit: vcf)                

    script:
        ext=vcf.getExtension()
        if(ext!="gz"){
            """
            bgzip -c ${vcf.name} > ${vcf.simpleName}.vcf.gz
            tabix -p vcf ${vcf.simpleName}.vcf.gz
            """
        } else {
            """
            tabix -p vcf ${vcf.simpleName}.vcf.gz
            """
        }
}