process AlignReads {
    tag {"STAR AlignReads ${sample_id} "}
    label 'STAR_2_7_3a'
    label 'STAR_2_7_3a_AlignReads'
    container = 'quay.io/biocontainers/star:2.7.3a--0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), val(rg_id), path(fastqs))
        path(star_genome_index)
        path(genome_gtf)
     

    output:
        tuple(val(sample_id), val(rg_id), path("${sample_id}_Aligned.sortedByCoord.out.bam"), emit: bam_file)
        path("*Log.final.out", emit: final_log)
        path("*Log.out", emit: log)
        path("*SJ.out.tab", emit: sj_table)
        path("*Unmapped*", optional: true, emit: fastqs_unaligned)


   
    script:
        def barcode = rg_id.split('_')[1]
        def avail_mem = task.memory ? "--limitBAMsortRAM ${task.memory.toBytes() - 100000000}" : ''   
        """
        STAR --genomeDir ${star_genome_index} \
            ${params.optional} \
            --readFilesIn ${fastqs} \
            --outFileNamePrefix ${sample_id}_ \
            --sjdbGTFfile ${genome_gtf} \
            --runDirPerm All_RWX ${avail_mem} \
            --readFilesCommand zcat \
            --outSAMtype BAM SortedByCoordinate \
            --runThreadN ${task.cpus} \
            --outSAMattrRGline ID:${sample_id} LB:${sample_id} PL:IllUMINA PU:${barcode} SM:${sample_id}  
        """
}
