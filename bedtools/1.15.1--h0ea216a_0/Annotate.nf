process Annotate {
    tag {"bedtools ${vcf_file}"}
    label 'bedtools_1_15_1'
    container = 'quay.io/biocontainers/bcftools:1.15.1--h0ea216a_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(path(vcf_file), path(vcf_file_index))

    output:
        path("${vcf_file.simpleName}_homopolymer.vcf")

    script:
        """
        echo "$params.info_field_homopolymer_bed" | bcftools annotate -a $params.homopolymer_bed -c $params.bed_colums -h /dev/stdin $vcf_file > "${vcf_file.simpleName}_homopolymer.vcf"
        """
}
