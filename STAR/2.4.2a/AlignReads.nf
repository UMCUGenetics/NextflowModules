process AlignReads {
    tag "${sample}_STAR"
    publishDir "$params.outdir/$sample/STAR", mode: 'copy'
    cpus 4
    penv 'threaded'
    memory '40 GB'
    time '1h'

    input:
    set val(sample), file(r1_fastqs), file(r2_fastqs)
    file(index)

    output:
    file "*Log.final.out"
    file '*.bam' 
    file "*.out" 
    file "*SJ.out.tab"
    file "*Log.out" 

    script:
    def barcode = r1_fastqs[1].getName().split('_')[1]
    def r1_fastqs = r1_fastqs.collect{ "$it" }.join(",")
    def r2_fastqs = r2_fastqs.collect{ "$it" }.join(",")
    

    """
    $params.star --runMode alignReads --readFilesIn $r1_fastqs $r2_fastqs \
        --runThreadN $task.cpus \
        --outFileNamePrefix $sample \
        --genomeDir $index \
        --outSAMtype BAM SortedByCoordinate \
        --readFilesCommand zcat \
        --twopassMode Basic \
        --outSJfilterIntronMaxVsReadN 10000000 \
        --chimJunctionOverhangMin 15 \
        --chimSegmentMin 15 \
        --outSAMattrRGline ID:"${sample}_${barcode}" PL:"ILLUMINA" PU:${barcode} SM:${sample} LB:${sample}
    """
}

