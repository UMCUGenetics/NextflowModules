process Annotate {
    tag {"BCFtools Annotate ${identifier}"}
    label 'BCFtools_1_15_1'
    label 'BCFtools_1_15_1_Annotate'
    container = 'quay.io/biocontainers/bcftools:1.15.1--h0ea216a_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple(val(identifier), path(input_vcf), path(input_vcf_index))

    output:
    tuple(val(identifier), path("${input_vcf.simpleName}.vcf"))

    script:
    """
    bcftools annotate ${params.optional} ${input_vcf} > ${input_vcf.simpleName}.vcf
    """
}
