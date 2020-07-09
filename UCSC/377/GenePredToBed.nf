process GenePredToBed {
    tag {"ucsc GenePredToBed ${genome_genepred.baseName}"}
    label 'ucsc_377'
    label 'ucsc_377_GenePredToBed'
    container = 'quay.io/biocontainers/ucsc-genepredtobed:377--h35c10e6_2'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        path(genome_genepred)

    output:
        path("${genome_genepred.baseName}.sorted.bed12", emit: genome_bed12)
  

    script:
        """
        genePredToBed ${genome_genepred} ${genome_genepred.baseName}.bed12
        sort -k1,1 -k2,2n ${genome_genepred.baseName}.bed12 > ${genome_genepred.baseName}.sorted.bed12
        """

}
