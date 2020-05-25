process GenotypeGVCFs {
    tag {"GATK GenotypeGVCFs ${run_id}.${interval}"}
    label 'GATK_4_1_3_0'
    label 'GATK_4_1_3_0_GenotypeGVCFs'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:gatk4.1.3.0'
    shell = ['/bin/bash', '-euo', 'pipefail']
    input:
        tuple (run_id, interval, path(gvcf), path(gvcfidx), path(interval_file))

    output:
        tuple (run_id, interval, path("${run_id}.${interval}.vcf"),path("${run_id}.${interval}.vcf.idx"),path(interval_file), emit : genotyped_vcfs)

    script:
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
        GenotypeGVCFs \
        -V $gvcf \
        -O ${run_id}.${interval}.vcf \
        -R ${params.genome_fasta} \
        -D ${params.genome_dbsnp} \
        -L $interval_file
        """
}
