process Merge {
    tag {"Sambamba Merge ${sample_id}"}
    label 'Sambamba_1_0_0'
    label 'Sambamba_1_0_0_Merge'
    container = 'quay.io/biocontainers/sambamba:1.0--h98b6b92_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam_files), path(bai_files))

    output:
        tuple(val(sample_id), path("${sample_id}.bam"), path("${sample_id}.bam.bai"), emit: bam_file)

    script:
        """
        sambamba merge -t ${task.cpus} ${sample_id}.bam ${bam_files}
        """
}
