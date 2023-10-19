process ViewSort {
    tag {"Sambamba ViewSort ${sample_id} - ${rg_id}"}
    label 'Sambamba_1_0_0'
    label 'Sambamba_1_0_0_ViewSort'
    container = 'quay.io/biocontainers/sambamba:1.0--h98b6b92_0'
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
