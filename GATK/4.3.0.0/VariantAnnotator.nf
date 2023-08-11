process VariantAnnotator {
    tag {"GATK VariantAnnotator ${run_id}"}
    label 'GATK_4_3_0_0'
    label 'GATK_4_3_0_0_VariantAnnotator'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'broadinstitute/gatk:4.3.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(run_id), path(vcf), path(vcfidx))

    output:
        tuple(val(run_id), path("${vcf.baseName}_${db_name}.${ext_vcf}"), path("${vcf.baseName}_${db_name}.${ext_index}"), emit: annotated_vcfs)

    script:
        db_file = file(params.genome_variant_annotator_db).getBaseName()
        db_name = db_file.replaceFirst(~/\.[^\.]+$/, '')

        ext_vcf = params.compress || vcf.getExtension() == ".gz" ? "vcf.gz" : "vcf"
        ext_index = params.compress || vcf.getExtension() == ".gz" ? "vcf.gz.tbi" : "vcf.idx"

        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" VariantAnnotator \
        --tmp-dir \$TMPDIR \
        -R ${params.genome_fasta} \
        -V $vcf \
        --output ${vcf.baseName}_${db_name}.${ext_vcf} \
        --dbsnp ${params.genome_variant_annotator_db} \
        """
}
