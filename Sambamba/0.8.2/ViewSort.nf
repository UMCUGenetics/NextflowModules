process ViewSort {
    tag {"Sambamba ViewSort ${sample_id} - ${rg_id}"}
    label 'Sambamba_0_8_2'
    label 'Sambamba_0_8_2_ViewSort'
    container = 'quay.io/biocontainers/sambamba:0.8.2--h98b6b92_2'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), val(rg_id), path(sam_file))

    output:
        tuple(val(sample_id), val(rg_id), path("${sam_file.baseName}.sort.bam"), path("${sam_file.baseName}.sort.bam.bai"), emit: bam_file)

    script:
        """
        sambamba view -t ${task.cpus} -S -f bam ${sam_file} | sambamba sort -t ${task.cpus} -m ${task.memory.toGiga()}G -o ${sam_file.baseName}.sort.bam /dev/stdin
        """
}
