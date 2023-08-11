process VariantFiltration {
    tag {"GATK VariantFiltration ${run_id}.${interval}.${type}"}
    label 'GATK_4_3_0_0'
    label 'GATK_4_3_0_0_VariantFiltration'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'broadinstitute/gatk:4.3.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(run_id), val(interval), val(type), path(vcf), path(vcftbi))

    output:
        tuple(val(run_id), val(interval), val(type), path("${run_id}.${interval}.${type}.filtered_variants.${ext_vcf}"), path("${run_id}.${interval}.${type}.filtered_variants.${ext_index}"), emit: filtered_vcfs)

    script:
        if (type == 'SNP'){
          filter_criteria = params.gatk_snp_filter
        } else if (type == 'RNA') {
           filter_criteria = params.gatk_rna_filter
        } else {
           filter_criteria = params.gatk_indel_filter
        }
        ext_vcf = params.compress || vcf.getExtension() == ".gz" ? "vcf.gz" : "vcf"
        ext_index = params.compress || vcf.getExtension() == ".gz" ? "vcf.gz.tbi" : "vcf.idx"

        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" VariantFiltration \
        --tmp-dir \$TMPDIR \
        ${params.optional} \
        -R $params.genome_fasta \
        -V $vcf \
        -O ${run_id}.${interval}.${type}.filtered_variants.${ext_vcf} \
        $filter_criteria
        """
}
