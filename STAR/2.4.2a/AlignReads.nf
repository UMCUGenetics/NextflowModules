process alignReads {
    tag {"STAR alignReads ${sample_id} - ${rg_id}"}
    label 'STAR_2_4_2a'
    label 'STAR_2_4_2a_alignReads'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.star_mem}" : ""
    container = '/hpc/cog_bioinf/ubec/tools/rnaseq_containers/star-2.4.2a-squashfs-pack.gz.squashfs'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, rg_id, file(fastqs) 
    file(genomeDir)

    output:
    tuple sample_id, rg_id, file("*.bam" ), file("${rg_id}.Log.final.out"), file("${rg_id}.Log.out"), file("${rg_id}.SJ.out.tab")
    
    script:
    def barcode = rg_id.split('_')[1]	
    
    """
    STAR --runMode alignReads --genomeDir $genomeDir \
    --readFilesIn $fastqs \
    --readFilesCommand zcat \
    --runThreadN ${task.cpus} \
    --outSAMtype BAM SortedByCoordinate \
    --outReadsUnmapped Fastx \
    --outFileNamePrefix ${rg_id}. \
    --twopassMode $params.star_twopassMode \
    --outSAMattrRGline ID:${rg_id} LB:${sample_id} PL:illumina PU:${barcode}" SM:${sample_id}"    
    """
}
