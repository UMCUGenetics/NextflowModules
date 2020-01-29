process Markdup {
    tag {"Sambamba Markdup ${sample_id} - ${rg_id}"}
    label 'Sambamba_0_7_0'
    label 'Sambamba_0_7_0_Markdup'
    container = 'quay.io/biocontainers/sambamba:0.7.0--h89e63da_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, rg_id, file(bam_file), file(bai_file)

    output:
    tuple sample_id, rg_id, file("${bam_file.baseName}.markdup.bam"), file("${bam_file.baseName}.markdup.bam.bai")

    script:
    """
    sambamba markdup -t ${task.cpus} $bam_file ${bam_file.baseName}.markdup.bam
    """
}