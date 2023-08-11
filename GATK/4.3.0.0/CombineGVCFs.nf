process CombineGVCFs {
    tag {"GATK CombineGVCFs ${run_id}.${interval}"}
    label 'GATK_4_3_0_0'
    label 'GATK_4_3_0_0_CombineGVCFs'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'broadinstitute/gatk:4.3.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(run_id), val(interval), path(gvcf_chunks), path(gvcf_chunk_idxs), path(interval_file))

    output:
        tuple(val(run_id), val(interval), path("${run_id}.${interval}.g.${ext_vcf}"), path("${run_id}.${interval}.g.${ext_index}"), path(interval_file), emit: combined_gvcfs)

    script:
        vcfs = gvcf_chunks.join(' -V ')
        ext_vcf = params.compress || gvcf_chunks.getExtension() == ".gz" ? "vcf.gz" : "vcf"
        ext_index = params.compress || gvcf_chunks.getExtension() == ".gz" ? "vcf.gz.tbi" : "vcf.idx"

        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" CombineGVCFs \
        --tmp-dir \$TMPDIR \
        -R ${params.genome_fasta} \
        -V $vcfs \
        -O ${run_id}.${interval}.g.${ext_vcf} \
        -L $interval_file
        """
}
