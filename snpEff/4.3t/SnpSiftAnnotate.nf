
process SnpSiftAnnotate {
    tag {"SNPEFF_snpsiftannotate ${run_id}"}
    label 'SNPEFF_4_3t'
    label 'SNPEFF_snpsiftannotate_4_3t'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.snpsiftannotate.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:snpeff-4.3t'
    
    input:
      tuple run_id, file(vcf), file(vcfidx)

    output:
      tuple run_id, file("${vcf.baseName}_${db_name}.vcf"), file("${vcf.baseName}_${db_name}.vcf.idx")

    script:
    db_file = file(params.genome_snpsift_annotate_db).getBaseName()
    db_name = db_file.replaceFirst(~/\.[^\.]+$/, '')

    """
    set -o pipefail

    java -Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR -jar /bin/SnpSift.jar annotate \
    ${params.snpsiftannotate.toolOptions} ${params.genome_snpsift_annotate_db} \
    $vcf > ${vcf.baseName}_${db_name}.vcf

    java -Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR -jar /bin/igvtools.jar index ${vcf.baseName}_${db_name}.vcf

    """
}
