
process VariantAnnotator {
    tag {"GATK VariantAnnotator ${run_id}"}
    label 'GATK_4_1_3_0'
    label 'GATK_4_1_3_0_VariantAnnotator'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:gatk4.1.3.0'
    shell = ['/bin/bash', '-euo', 'pipefail']
    input:
        tuple (run_id, path(vcf), path(vcfidx))

    output:
        tuple (run_id, path("${vcf.baseName}_${db_name}.vcf"), path("${vcf.baseName}_${db_name}.vcf.idx"), emit: annotated_vcfs)

    script:
        db_file = file(params.genome_variant_annotator_db).getBaseName()
        db_name = db_file.replaceFirst(~/\.[^\.]+$/, '')

        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
        VariantAnnotator \
        -R ${params.genome_fasta} \
        -V $vcf \
        --output ${vcf.baseName}_${db_name}.vcf \
        --dbsnp ${params.genome_variant_annotator_db} \
        """
}
