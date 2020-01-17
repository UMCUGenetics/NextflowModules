process alignReads {
    tag {"STAR alignReads ${sample_id} - ${rg_id}"}
    label 'STAR_2_4_2a'
    label 'STAR_2_4_2a_alignReads'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.star_mem}" : ""
    container = '/hpc/cog_bioinf/ubec/tools/rnaseq_containers/star-2.4.2a-squashfs-pack.gz.squashfs'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, rg_id, file(r1_fastqs), file(r2_fastqs)
    file(genomeDir)
    

    output:
    tuple sample_id, file("*.bam" ), file("*Unmapped*"), file("*Log.final.out"), file("*Log.out"), file("*SJ.out.tab")
     
   
    script:
    def barcode = rg_id.split('_')[1]	
    String arg_1 = String.join(",", r1_fastqs.collect{ "$it" }.join(","));
    String arg_2 = ""
     
    if ( !params.singleEnd ){
         arg_2 = String.join(",", r2_fastqs.collect{ "$it" }.join(","));
    }

    def read_args = !params.singleEnd ? "--readFilesIn $arg_1 $arg_2" :"--readFilesIn $arg_1"   
    
    """
    STAR --runMode alignReads --genomeDir $genomeDir $read_args \
    --readFilesCommand zcat \
    --runThreadN ${task.cpus} \
    --outSAMtype BAM SortedByCoordinate \
    --outReadsUnmapped Fastx \
    --outFileNamePrefix ${sample_id}. \
    --twopassMode $params.star_twopassMode \
    --outSAMattrRGline ID:${rg_id} LB:${sample_id} PL:illumina PU:${barcode}" SM:${sample_id}"
    """
     
}




