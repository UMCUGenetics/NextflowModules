process CombineGVCFs {
    tag {"GATK_combinegvcfs ${run_id}.${interval}"}
    label 'GATK_4_1_3_0'
    label 'GATK_combinegvcfs_4_1_3_0'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.combinegvcfs.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:gatk4.1.3.0'

    input:
      tuple run_id, interval, file(gvcf_chunks), file(gvcf_chunk_idxs), file(interval_file)
    output:
      tuple run_id, interval, file("${run_id}.${interval}.g.vcf"), file("${run_id}.${interval}.g.vcf.idx"),file(interval_file)

    script:
    vcfs = gvcf_chunks.join(' -V ')

    """

    gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
    CombineGVCFs \
    -R $params.genome_fasta \
    -V $vcfs \
    -O ${run_id}.${interval}.g.vcf \
    -L $interval_file
    """
}
