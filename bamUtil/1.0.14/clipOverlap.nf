process clipOverlap {
    tag {"bamUtil clipOverlap ${sample_id} - ${rg_id}"}
    label 'bamUtil_1_0_14'
    label 'bamUtil_1_0_14_clipOverlap'
    container = 'quay.io/biocontainers/bamutil:1.0.14--h635df5c_3'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, rg_id, file(bam_file), file(bai_file)

    output:
    tuple sample_id, rg_id, file("${bam_file.baseName}.clipped.bam")

    script:
    """
    bam clipOverlap --in $bam_file --out ${bam_file.baseName}.clipped.bam
    """
}
