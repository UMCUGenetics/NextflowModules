process ViewUnmapped {
    tag {"Sambamba ViewUnmapped ${sample_id}"}
    label 'Sambamba_1_0_0'
    label 'Sambamba_1_0_0_ViewUnmapped'
    container = 'quay.io/biocontainers/sambamba:1.0--h98b6b92_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam_file), path(bai_file))

    output:
        tuple(val(sample_id), path("${bam_file.baseName}.unmapped.bam"), path("${bam_file.baseName}.unmapped.bam.bai"), emit: bam_file)

    script:
        """
        sambamba view -t ${task.cpus} -f bam -F 'unmapped and mate_is_unmapped' ${bam_file} > ${bam_file.baseName}.unmapped.bam
        sambamba index -t ${task.cpus} ${bam_file.baseName}.unmapped.bam
        """
}
