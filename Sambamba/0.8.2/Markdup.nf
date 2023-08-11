process Markdup {
    tag {"Sambamba Markdup ${sample_id}"}
    label 'Sambamba_0_8_2'
    label 'Sambamba_0_8_2_Markdup'
    container = 'quay.io/biocontainers/sambamba:0.8.2--h98b6b92_2'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), val(rg_id), path(bam_file), path(bai_file))

    output:
        tuple(val(sample_id), val(rg_id), path("${bam_file.baseName}.markdup.bam"), path("${bam_file.baseName}.markdup.bam.bai"), emit: bam_file)

    script:
        """
        sambamba markdup -t ${task.cpus} ${bam_file} ${bam_file.baseName}.markdup.bam
        """
}

process MarkdupMerge {
    tag {"Sambamba MarkdupMerge ${sample_id}"}
    label 'Sambamba_0_8_2'
    label 'Sambamba_0_8_2_MarkdupMerge'
    container = 'quay.io/biocontainers/sambamba:0.8.2--h98b6b92_2'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam_files))

    output:
        tuple(val(sample_id), path("${sample_id}.markdup.bam"), path("${sample_id}.markdup.bam.bai"), emit: bam_file)

    script:
        """
        sambamba markdup -t ${task.cpus} ${bam_files} ${sample_id}.markdup.bam
        """
}
