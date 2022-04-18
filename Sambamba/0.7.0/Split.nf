process Split {
    tag {"Sambamba Split ${sample_id}"}
    label 'Sambamba_0_7_0'
    label 'Sambamba_0_7_0_Split'
    container = 'quay.io/biocontainers/sambamba:0.7.0--h89e63da_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(bam_file), path(bai_file))

    output:
        tuple(sample_id, path("${bam_file.baseName}_hap1.bam"), path("${bam_file.baseName}_hap1.bam.bai"), path("${bam_file.baseName}_hap2.bam"), path("${bam_file.baseName}_hap2.bam.bai"),path("${bam_file.baseName}_nohap.bam"), path("${bam_file.baseName}_nohap.bam.bai"))

    script:
        """
        sambamba view -t ${task.cpus} -F "[HP] == 1" -f bam ${bam_file} > ${bam_file.baseName}_hap1.bam
        sambamba view -t ${task.cpus} -F "[HP] == 1" -f bam ${bam_file} > ${bam_file.baseName}_hap2.bam
        sambamba view -t ${task.cpus} -F "[HP] == null" -f bam ${bam_file} > ${bam_file.baseName}_nohap.bam
        sambamba index -t ${task.cpus} ${bam_file.baseName}_hap1.bam
        sambamba index -t ${task.cpus} ${bam_file.baseName}_hap2.bam
        sambamba index -t ${task.cpus} ${bam_file.baseName}_nohap.bam
        """
}
