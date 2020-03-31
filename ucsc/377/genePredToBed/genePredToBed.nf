process genePredToBed {
    tag {"ucsc genePredToBed ${sample_id}"}
    label 'ucsc_377'
    label 'ucsc_377_genePredToBed'
    container = 'quay.io/biocontainers/ucsc-genepredtobed:377--h35c10e6_2'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    file(genome_genepred)

    output:
    file("${genome_genepred.baseName}.genePred")


    script:
    """
    genePredToBed ${genome_genepred} > ${genome_genepred.baseName}.bed12
    sort -k1,1 -k2,2n ${genome_genepred.baseName}.bed12 > ${genome_genepred.baseName}.sorted.bed12
    """

}
