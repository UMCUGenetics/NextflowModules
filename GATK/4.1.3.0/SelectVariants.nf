process SelectVariants {
    tag {"GATK SelectVariants ${run_id}.${interval}.${type}"}
    label 'GATK_4_1_3_0'
    label 'GATK_4_1_3_0_SelectVariants'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:gatk4.1.3.0'
    shell = ['/bin/bash', '-euo', 'pipefail']
    input:
        tuple (val(run_id), val(interval), path(vcf), path(vcfidx), type)

    output:
        tuple (val(run_id), val(interval), val(type), path("${run_id}.${interval}.${type}.tmp.vcf"), path("${run_id}.${interval}.${type}.tmp.vcf.idx"), emit: selected_vcfs)

    script:
        select_type = type == 'SNP' ? '--select-type SNP --select-type NO_VARIATION' : '--select-type INDEL --select-type MIXED'
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
        SelectVariants \
        -R ${params.genome_fasta} \
        -V $vcf \
        -O ${run_id}.${interval}.${type}.tmp.vcf \
        $select_type \
        --tmp-dir \$TMPDIR
        """
}
