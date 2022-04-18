process ToSAM {
    tag {"Sambamba ToSAM ${sample_id}"}
    label 'Sambamba_0_7_0_ToSAM'
    container = 'quay.io/biocontainers/sambamba:0.7.0--h89e63da_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(bam_file), path(bai_file))

    output:
        tuple(sample_id, path("${bam_file.baseName}.sam"))

    script:
        """
        sambamba view -h -t ${task.cpus} ${bam_file} > ${bam_file.baseName}.sam
        """
}
