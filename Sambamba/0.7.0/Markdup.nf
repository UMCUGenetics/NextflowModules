process Markdup {
    tag {"Sambamba Markdup ${sample_id}"}
    label 'Sambamba_0_7_0'
    label 'Sambamba_0_7_0_Markdup'
    container = 'quay.io/biocontainers/sambamba:0.7.0--h89e63da_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, rg_id, path(bam_file), path(bai_file))
    output:
        tuple(sample_id, rg_id, path("${bam_file.baseName}.markdup.bam"), path("${bam_file.baseName}.markdup.bam.bai"), emit: bam_file)

    script:
        """
        sambamba markdup -t ${task.cpus} ${bam_file} ${bam_file.baseName}.markdup.bam
        """
}

process MarkdupMerge {
    tag {"Sambamba MarkdupMerge ${sample_id}"}
    label 'Sambamba_0_7_0'
    label 'Sambamba_0_7_0_MarkdupMerge'
    container = 'quay.io/biocontainers/sambamba:0.7.0--h89e63da_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(bam_files))

    output:
        tuple(sample_id, path("${sample_id}.markdup.bam"), path("${sample_id}.markdup.bam.bai"), emit: bam_file)

    script:
        """
        sambamba markdup -t ${task.cpus} ${bam_files} ${sample_id}.markdup.bam
        """
}
