process SNPSiftDbnsfp {
    tag {"SNPEff SNPSiftDbnsfp ${run_id}"}
    label 'SNPEff_5_1d'
    label 'SNPEff_5_1d_SNPSiftDbnsfp'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'quay.io/biocontainers/snpsift:5.1d--hdfd78af_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(run_id), path(vcf), path(vcfidx))

    output:
        tuple(val(run_id), path("${vcf.baseName}_dbnsfp.vcf"), emit : snpsift_dbnsfp_vcfs)

    script:
        """
        SnpSift -Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR dbnsfp -v \
        ${params.optional} \
        -db ${params.genome_dbnsfp} $vcf > ${vcf.baseName}_dbnsfp.vcf
        """
}
