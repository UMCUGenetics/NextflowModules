process Markdup {
    tag {"Sambamba Markdup ${sample_id}"}
    label 'Sambamba_1_0_0'
    label 'Sambamba_1_0_0_Markdup'
    container = 'quay.io/biocontainers/sambamba:1.0--h98b6b92_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), val(rg_id), path(bam_file), path(bai_file))
    output:
        tuple(val(sample_id), val(rg_id), path("${bam_file.baseName}.markdup.bam"), path("${bam_file.baseName}.markdup.bam.bai"), emit: bam_file)
        path("${bam_file.baseName}.markdup.txt", emit: stats_file)

    script:
        """
        sambamba markdup -t ${task.cpus} --tmpdir=\$TMPDIR \
        ${bam_file} ${bam_file.baseName}.markdup.bam \
        2> ${bam_file.baseName}.markdup.txt
        """
}

process MarkdupMerge {
    tag {"Sambamba MarkdupMerge ${sample_id}"}
    label 'Sambamba_1_0_0'
    label 'Sambamba_1_0_0_MarkdupMerge'
    container = 'quay.io/biocontainers/sambamba:1.0--h98b6b92_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam_files))

    output:
        tuple(val(sample_id), path("${sample_id}.markdup.bam"), path("${sample_id}.markdup.bam.bai"), emit: bam_file)
        path("${sample_id}.markdup.txt", emit: stats_file)

    script:
        """
        sambamba markdup -t ${task.cpus} --tmpdir=\$TMPDIR \
        ${bam_files} ${sample_id}.markdup.bam \
        2> ${sample_id}.markdup.txt
        """
}
