
process SNPSiftAnnotate {
    tag {"SNPEff SNPSiftAnnotate ${run_id}"}
    label 'SNPEff_4_3t'
    label 'SNPEff_4_3t_SNPSiftAnnotate'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:snpeff-4.3t'
    shell = ['/bin/bash', '-euo', 'pipefail']
    input:
        tuple (run_id, path(vcf), path(vcfidx))

    output:
        tuple (run_id, path("${vcf.baseName}_${db_name}.vcf"), path("${vcf.baseName}_${db_name}.vcf.idx"), emit: snpsift_annoted_vcfs)

    script:
        db_file = file(params.genome_snpsift_annotate_db).getBaseName()
        db_name = db_file.replaceFirst(~/\.[^\.]+$/, '')

        """
        set -o pipefail

        java -Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR -jar /bin/SnpSift.jar annotate \
        ${params.optional} ${params.genome_snpsift_annotate_db} \
        $vcf > ${vcf.baseName}_${db_name}.vcf

        java -Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR -jar /bin/igvtools.jar index ${vcf.baseName}_${db_name}.vcf

        """
}
