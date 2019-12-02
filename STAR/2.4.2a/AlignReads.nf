process alignReads {
    tag {"STAR_alignReads ${sample_id} - ${rg_id}"}
    label 'STAR_alignReads_2_4_2a'

    input:
    tuple val(sample), file(r1_fastqs), file(r2_fastqs)
    file(index)

    output:
    tuple sample_id,rg_id,file ("${sample_id}Aligned.sortedByCoord.out.bam" )
    file ("${sample_id}Aligned.sortedByCoord.out.bam.bai" )
    file ("${sample_id}.Log.final.out")
    file ("${sample_id}.Log.out")
    file ("${sample_id}.SJ.out.tab")
    file ("${sample_id}.Log.progress.out") 

    shell:
    def barcode = rg_id.split('_')[1]
    def r1_fastqs = r1_fastqs.collect{ "$it" }.join(",")
    def r2_fastqs = r2_fastqs.collect{ "$it" }.join(",")

    """
    STAR --runMode alignReads --readFilesIn $r1_fastqs $r2_fastqs \
        --runThreadN $params.star_mem \
        --outFileNamePrefix $sample_id. \
        --genomeDir $index \
        --outSAMtype BAM SortedByCoordinate \
        --readFilesCommand zcat \
        --twopassMode $params.star_two_pass__mode \
        --outSAMattrRGline ID:"${sample_id}" PL:"ILLUMINA" PU:"${barcode}" SM:"${sample_id}" LB:"${sample_id}"
    """
}

