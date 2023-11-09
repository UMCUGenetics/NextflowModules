process VariantCaller {
    tag { "Clair3 VariantCaller ${bam_file.baseName}" }
    label 'Clair3_1_0_4'
    label 'Clair3_1_0_4_VariantCaller'
    container = 'quay.io/biocontainers/clair3:1.0.4--py39hf5e1c6e_3'
    shell = ['/bin/bash', '-euo', 'pipefail']

    publishDir "clair3/", saveAs: { filename -> "${bam_file.baseName}.vcf.gz" }, mode: 'copy', pattern: 'merge_output.vcf.gz'
    publishDir "clair3/", saveAs: { filename -> "${bam_file.baseName}.vcf.gz.tbi" }, mode: 'copy', pattern: 'merge_output.vcf.gz.tbi'

    input:
        tuple(path(bam_file), path(bai_file))

    output:
        path("*")

    script:
        """
        run_clair3.sh \
            --bam_fn=${bam_file} \
            --ref_fn=${params.genome} \
            --output=./ \
            --model_path=${params.clair3model} \
            --sample_name=${bam_file.baseName} \
            --threads=${task.cpus} \
            ${params.optional}
        """
}
