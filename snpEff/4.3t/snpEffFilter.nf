
process SNPEffFilter {
    tag {"SNPEff SNPEffFilter ${run_id}"}
    label 'SNPEff_4_3t'
    label 'SNPEff_4_3t_SNPEffFilter'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:snpeff-4.3t'
    shell = ['/bin/bash', '-euo', 'pipefail']
    input:
        tuple (run_id, path(vcf), path(vcfidx))

    output:
        tuple (run_id, path("${vcf.baseName}.filtered_variants.vcf"), path("${vcf.baseName}.filtered_variants.vcf.idx"), emit: snpeff_filtered_vcfs)

    script:
        """
        java -Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR -jar /bin/snpEff.jar \
        -c snpEff.config ${params.optional} \
        -v $vcf \
        > ${vcf.baseName}.filtered_variants.vcf

        java -Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR -jar /bin/igvtools.jar index ${vcf.baseName}.filtered_variants.vcf
        """
}
