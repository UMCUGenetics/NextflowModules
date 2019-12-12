process ViewSort {
    tag {"Sambamba ViewSort ${sample_id} - ${rg_id}"}
    label 'Sambamba_0.7.0'
    label 'Sambamba_0.7.0_ViewSort'
    container = 'quay.io/biocontainers/sambamba:0.7.0--h89e63da_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, rg_id, file(sam_file)

    output:
    tuple sample_id, rg_id, file("${rg_id}.sort.bam"), file("${rg_id}.sort.bam.bai")

    script:
    """
    sambamba view -t ${task.cpus} -S -f bam $sam_file | sambamba sort -t ${task.cpus} -o ${rg_id}.sort.bam /dev/stdin
    """
}
