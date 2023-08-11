process SNPEffFilter {
    tag {"SNPEff SNPEffFilter ${run_id}"}
    label 'SNPEff_5_1d'
    label 'SNPEff_5_1d_SNPEffFilter'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'quay.io/biocontainers/snpeff:5.1d--hdfd78af_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(run_id), path(vcf), path(vcfidx))

    output:
        tuple(val(run_id), path("${vcf.simpleName}.filtered_variants.vcf"), emit: snpeff_filtered)

    script:
        print params.snpeff_datadir
        if( !params.snpeff_datadir || params.snpeff_datadir==null|| params.snpeff_datadir=="" || params.snpeff_datadir=="null" ){
            datadir="\$TMPDIR"
        } else {
            datadir=params.snpeff_datadir
        }
        """
        snpEff -Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR \
        -c snpEff.config \
        ${params.snpeff_genome} \
        ${params.optional} \
	-dataDir ${datadir} \
        -v $vcf \
        > ${vcf.simpleName}.filtered_variants.vcf
        """
}
