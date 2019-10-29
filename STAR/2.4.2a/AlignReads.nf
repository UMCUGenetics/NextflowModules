process AlignReads {
    tag "${sample}_STAR"
    publishDir "$params.outdir/$sample/STAR", mode: 'copy'

    input:
    set val(sample), file(r1_fastqs), file(r2_fastqs)
    file(index)

    output:
    set val(sample),file ("${sample}.sorted.mdup.bam" )
    file ("${sample}.sorted.mdup.bam.bai" )
    file ("${sample}.Log.final.out")
    file ("${sample}.Log.out")
    file ("${sample}.SJ.out.tab")
    file ("${sample}.Log.progress.out") 

    shell:
    def barcode = r1_fastqs[1].simpleName
    def r1_fastqs = r1_fastqs.collect{ "$it" }.join(",")
    def r2_fastqs = r2_fastqs.collect{ "$it" }.join(",")

    """
    $params.star --runMode alignReads --readFilesIn $r1_fastqs $r2_fastqs \
        --runThreadN $params.star_mem \
        --outFileNamePrefix $sample. \
        --genomeDir $index \
        --outSAMtype BAM SortedByCoordinate \
        --readFilesCommand zcat \
        --twopassMode Basic \
        --outSAMattrRGline ID:"${sample}_${barcode}" PL:"ILLUMINA" PU:${barcode} SM:${sample} LB:${sample}
    
    sambamba index -p -t $task.cpus ${sample}.Aligned.sortedByCoord.out.bam ${sample}.Aligned.sortedByCoord.out.bam.bai
    sambamba markdup --tmpdir=\$PWD/tmp --overflow-list-size=${params.sambamba_listsize} -p -t $task.cpus ${sample}.Aligned.sortedByCoord.out.bam  ${sample}.sorted.mdup.bam
    sambamba flagstat -p -t $task.cpus ${sample}.sorted.mdup.bam
    """
}

