process view_sort {
    container = 'quay.io/biocontainers/sambamba:0.7.0--h89e63da_1'
    tag {"SambambaViewSort ${sample_id} - ${rg_id}"}
    
    input:
    set sample, rg_id, file(sam_file)

    output:
    set sample, rg_id, file("${rg_id}.sort.bam"), file("${rg_id}.sort.bam.bai")

    script:
    """
    sambamba view -t ${task.cpus} -S -f bam $sam_file | sambamba sort -t ${task.cpus} -o ${rg_id}.sort.bam /dev/stdin
    """
}
