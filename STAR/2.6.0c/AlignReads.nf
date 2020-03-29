process AlignReads {
    tag {"STAR AlignReads ${sample_id} "}
    label 'STAR_2_6_0c'
    label 'STAR_2_6_0c_AlignReads'
    container = 'quay.io/biocontainers/star:2.6.0c--2'
    //container = '/hpc/local/CentOS7/cog_bioinf/nextflow_containers/STAR/star-2.4.2a-squashfs-pack.gz.squashfs'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, rg_id, file(r1_fastqs), file(r2_fastqs)
    file(star_genome_index)
    

    output:
    tuple sample_id, file("*.bam" ), file("*Unmapped*"), file("*Log.final.out"), file("*Log.out"), file("*SJ.out.tab")
     
   
    script:
    def barcode = rg_id.split('_')[1]
    def r1_args = r1_fastqs.collect{ "$it" }.join(",")
    def r2_args
    if ( !params.singleEnd ){
         r2_args = r2_fastqs.collect{ "$it" }.join(",") 
    }
    def read_args = !params.singleEnd ? "--readFilesIn ${r1_args} ${r2_args}" :"--readFilesIn ${r1_args}"    
    """
    STAR --genomeDir ${star_genome_index} ${read_args} ${params.optional} \
    --readFilesCommand zcat \
    --runThreadN ${task.cpus} \
    --outSAMtype BAM SortedByCoordinate \
    --outFileNamePrefix ${sample_id}. \
    --outSAMattrRGline ID:${rg_id} LB:${sample_id} PL:IllUMINA PU:${barcode} SM:${sample_id} 
    """
}
