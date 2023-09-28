process SNPSiftAnnotate {
    tag {"SNPEff SNPSiftAnnotate ${run_id}"}
    label 'SNPEff_5_1d'
    label 'SNPEff_5_1d_SNPSiftAnnotate'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'quay.io/biocontainers/snpsift:5.1d--hdfd78af_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(run_id), path(vcf), path(vcfidx))

    output:
        tuple(val(run_id), path("${vcf.baseName}_${db_name}.vcf"), emit: snpsift_annoted_vcfs)

    script:
        db_file = file(params.genome_snpsift_annotate_db).getBaseName()
        db_name = db_file.replaceFirst(~/\.[^\.]+$/, '')

        """
        set -o pipefail
        SnpSift -Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR annotate \
        ${params.optional} \
        ${params.genome_snpsift_annotate_db} \
        $vcf > ${vcf.baseName}_${db_name}.vcf
        """
}
