process gtfToGenePred {
    tag {"ucsc gtfToGenePred ${sample_id}"}
    label 'ucsc_377'
    label 'ucsc_377_gtfToGenePred'
    container = 'quay.io/biocontainers/ucsc-gtftogenepred:377--h35c10e6_2'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    file(genome_gtf)

    output:
    file("${genome_gtf.baseName}.genePred")


    script:
    """
    gtfToGenePred ${genome_gtf} ${genome_gtf.baseName}.genePred
    """

}
