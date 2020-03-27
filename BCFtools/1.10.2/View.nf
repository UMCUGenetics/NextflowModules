process View_bcf_vcf {
    // BCFtools view can use different input and output files, this process converts bcf to vcf files.
    tag {"BCFtools View_BCF_VCF ${sample_id}"}
    label 'BCFtools_1_10_2'
    label 'BCFtools_1_10_2_View_BCF_VCF'
    container = 'quay.io/biocontainers/bcftools:1.10.2--hd2cd319_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, file(bcf_file)

    output:
    tuple sample_id, file("${bcf_file.baseName}.vcf")

    script:
    """
    bcftools view ${params.optional} ${bcf_file} > ${bcf_file.baseName}.vcf
    """
}
