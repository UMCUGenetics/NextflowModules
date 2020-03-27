process Merge {
    tag {"Sambamba Merge ${sample_id}"}
    label 'Sambamba_0_7_0'
    label 'Sambamba_0_7_0_Merge'
    container = 'quay.io/biocontainers/sambamba:0.7.0--h89e63da_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, file(bam_files), file(bai_files)

    output:
    tuple sample_id, file("${sample_id}.bam"), file("${sample_id}.bam.bai")

    script:
    """
    sambamba merge -t ${task.cpus} ${sample_id}.bam ${bam_files}
    """
}
