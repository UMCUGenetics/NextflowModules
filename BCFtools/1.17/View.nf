process View_bcf_vcf {
    // BCFtools view can use different input and output files, this process converts bcf to vcf files.
    tag {"BCFtools View_BCF_VCF ${sample_id}"}
    label 'BCFtools_1_17'
    label 'BCFtools_1_17_View_BCF_VCF'
    container = 'quay.io/biocontainers/bcftools:1.17--h3cc50cf_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), file(input_file))

    output:
        tuple(val(sample_id), file("${input_file.baseName}.${extension}"))

    script:
        extension = input_file.getExtension() == "vcf" ? "bcf" : "vcf"
        """
        bcftools view ${params.optional} ${input_file} > ${input_file.baseName}.${extension}
        """
}
