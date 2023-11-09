process Split {
    tag {"Sambamba Split ${sample_id}"}
    label 'Sambamba_1_0_0'
    label 'Sambamba_1_0_0_Split'
    container = 'quay.io/biocontainers/sambamba:1.0--h98b6b92_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(bam_file), path(bai_file))

    output:
        tuple(sample_id, path("${bam_file.simpleName}_hap1.bam"), path("${bam_file.simpleName}_hap1.bam.bai"), path("${bam_file.simpleName}_hap2.bam"), path("${bam_file.simpleName}_hap2.bam.bai"),path("${bam_file.simpleName}_nohap.bam"), path("${bam_file.simpleName}_nohap.bam.bai"))

    script:
        """
        sambamba view -t ${task.cpus} -F "[HP] == 1" -f bam ${bam_file} > ${bam_file.simpleName}_hap1.bam
        sambamba view -t ${task.cpus} -F "[HP] == 2" -f bam ${bam_file} > ${bam_file.simpleName}_hap2.bam
        sambamba view -t ${task.cpus} -F "[HP] == null" -f bam ${bam_file} > ${bam_file.simpleName}_nohap.bam
        sambamba index -t ${task.cpus} ${bam_file.simpleName}_hap1.bam
        sambamba index -t ${task.cpus} ${bam_file.simpleName}_hap2.bam
        sambamba index -t ${task.cpus} ${bam_file.simpleName}_nohap.bam
        """
}