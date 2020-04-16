process AlignReads {
    tag {"STAR AlignReads ${sample_id} "}
    label 'STAR_2_7_3a'
    label 'STAR_2_7_3a_AlignReads'
    container = 'quay.io/biocontainers/star:2.7.3a--0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, rg_id, file(r1_fastqs), file(r2_fastqs)
    file(star_genome_index)
    

    output:
    tuple sample_id, file("${sample_id}_Aligned.sortedByCoord.out.bam" ), file("*Unmapped*"), file("*Log.final.out"), file("*Log.out"), file("*SJ.out.tab")
     
   
    script:
    def barcode = rg_id.split('_')[1]
    def r1_args = r1_fastqs.collect{ "$it" }.join(",")
    def r2_args
    if ( !params.singleEnd ){
         r2_args = r2_fastqs.collect{ "$it" }.join(",") 
    }
    def read_args = params.singleEnd ? "--readFilesIn ${r1_args}" :"--readFilesIn ${r2_args} ${r1_args}"    
    """
    STAR --genomeDir ${star_genome_index} \
         ${params.optional} \
         ${read_args} \
         --outFileNamePrefix ${sample_id}_ \
         --runThreadN ${task.cpus} \
         --outSAMattrRGline ID:${rg_id} LB:${sample_id} PL:IllUMINA PU:${barcode} SM:${sample_id}
    """
}
