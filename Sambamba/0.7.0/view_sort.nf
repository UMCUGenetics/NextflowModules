process MEM {
    container = 'quay.io/biocontainers/sambamba:0.7.0--h89e63da_16'
    tag {"Sambamba View Sort ${sample_id} - ${rg_id}"}
    publishDir "$params.outdir/$sample/Sambamba_view_sort", mode: 'copy'
    cpus 1
    penv 'threaded'
    memory '1 GB'
    time '1h'

    input:
    set sample, rg_id, file(sam_file)

    output:
    set sample, rg_id, file("${rg_id}.sort.bam")

    script:
    """
    sambamba view -t ${task.cpus} -S -f bam $sam_file | sambamba sort -t ${task.cpus} -o ${rg_id}.sort.bam"
    """
}
