process CombineGVCFs {
    tag {"CombineGVCFs ${run_id}.${interval}"}
    label 'GATK'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.combinegvcfs_mem}" : ""

    input:
      tuple run_id, interval, file(gvcf_chunks), file(gvcf_chunk_idxs), file(interval_file)
    output:
      tuple run_id, interval, file("${run_id}.${interval}.g.vcf"), file("${run_id}.${interval}.g.vcf.idx"),file(interval_file)

    script:
    vcfs = gvcf_chunks.join(' -V ')

    """

    gatk --java-options -Xmx${task.memory.toGiga()-4}g \
    CombineGVCFs \
    -R $params.genome_fasta \
    -V $vcfs \
    -O ${run_id}.${interval}.g.vcf \
    -L $interval_file
    """
}
