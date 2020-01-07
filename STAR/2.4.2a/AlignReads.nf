nextflow.preview.dsl=2

process alignReads {
    tag {"STAR alignReads ${sample_id} - ${rg_id}"}
    label 'STAR_2_4_2a'
    label 'STAR_2_4_2a_alignReads'
    container = '/hpc/cog_bioinf/ubec/tools/rnaseq_containers/star_2_4_2a-squashfs-pack.gz.squashfs'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.star_mem}" : ""
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, rg_id, file(fastqs: "*") 
    file(index)

    output:
    tuple sample_id, rg_id, file("${rg_id}.Aligned.sortedByCoord.out.bam" ),file("${rg_id}.Log.final.out"), file("${rg_id}.Log.out"), file("${rg_id}.SJ.out.tab")
    
    script:
    def barcode = rg_id.split('_')[1]

    """
    STAR --runMode alignReads --readFilesIn $fastqs \
        --runThreadN ${task.cpus} \
        --outFileNamePrefix $rg_id. \
        --genomeDir $index \
        --outSAMtype BAM SortedByCoordinate \
        --readFilesCommand zcat \
        --twopassMode Basic \
        --outSAMattrRGline ID:"${rg_id}" PL:"ILLUMINA" PU:"${barcode}" SM:"${sample_id}" LB:"${sample_id}"
    """
}
