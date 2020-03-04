process AlignReads {
    tag {"STAR AlignReads ${sample_id} "}
    label 'STAR_2_4_2a'
    label 'STAR_2_4_2a_AlignReads'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.star_mem}" : ""
    container = '/hpc/local/CentOS7/cog_bioinf/nextflow_containers/STAR/star-2.4.2a-squashfs-pack.gz.squashfs'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, rg_id, file(r1_fastqs), file(r2_fastqs)
    file(genomeDir)
    

    output:
    tuple sample_id, file("*.bam" ), file("*Unmapped*"), file("*Log.final.out"), file("*Log.out"), file("*SJ.out.tab")
     
   
    script:
    def r1_args = r1_fastqs.collect{ "$it" }.join(",")
    def r2_args
    if ( !params.singleEnd ){
         r2_args = r2_fastqs.collect{ "$it" }.join(",") 
    }
    def read_args = !params.singleEnd ? "--readFilesIn $r1_args $r2_args" :"--readFilesIn $r1_args"   

    """
    STAR --runMode alignReads --genomeDir $genomeDir $read_args \
    --readFilesCommand zcat \
    --runThreadN ${task.cpus} \
    --outSAMtype BAM SortedByCoordinate \
    --outReadsUnmapped Fastx \
    --outFileNamePrefix ${sample_id}. \
    --twopassMode $params.star_twopassMode 
    """
}
