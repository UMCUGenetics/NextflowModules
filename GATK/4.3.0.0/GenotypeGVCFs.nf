process GenotypeGVCFs {
    tag {"GATK GenotypeGVCFs ${run_id}.${interval}"}
    label 'GATK_4_3_0_0'
    label 'GATK_4_3_0_0_GenotypeGVCFs'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'broadinstitute/gatk:4.3.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(run_id), val(interval), path(gvcf), path(gvcftbi), path(interval_file))

    output:
        tuple(
            val(run_id),
            val(interval),
            path("${run_id}.${interval}.${ext_vcf}"),
            path("${run_id}.${interval}.${ext_index}"),
            path(interval_file),
            emit : genotyped_vcfs
        )

    script:
        ext_vcf = params.compress || gvcf.getExtension() == "gz" ? "vcf.gz" : "vcf"
        ext_index = params.compress || gvcf.getExtension() == "gz" ? "vcf.gz.tbi" : "vcf.idx"
        db = params.genome_dbsnp ? "-D ${params.genome_dbsnp}" : ""

        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" GenotypeGVCFs \
        --tmp-dir \$TMPDIR \
        -V $gvcf \
        -O ${run_id}.${interval}.${ext_vcf} \
        -R ${params.genome_fasta} \
        ${db} \
        -L $interval_file
        """
}
