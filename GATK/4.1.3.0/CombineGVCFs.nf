process CombineGVCFs {
    tag {"GATK CombineGVCFs ${run_id}.${interval}"}
    label 'GATK_4_1_3_0'
    label 'GATK_4_1_3_0_CombineGVCFs'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:gatk4.1.3.0'
    shell = ['/bin/bash', '-euo', 'pipefail']
    input:
      tuple(val(run_id), val(interval), path(gvcf_chunks), path(gvcf_chunk_idxs), path(interval_file))
    output:
      tuple(val(run_id), val(interval), path("${run_id}.${interval}.g.vcf"), path("${run_id}.${interval}.g.vcf.idx"), path(interval_file), emit: combined_gvcfs)

    script:
        vcfs = gvcf_chunks.join(' -V ')

        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
        CombineGVCFs \
        -R ${params.genome_fasta} \
        -V $vcfs \
        -O ${run_id}.${interval}.g.vcf \
        -L $interval_file \
        --tmp-dir \$TMPDIR
        """
}
