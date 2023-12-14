process ToSAM {
    tag {"Sambamba ToSAM ${sample_id}"}
    label 'Sambamba_1_0_0_ToSAM'
    container = 'quay.io/biocontainers/sambamba:1.0--h98b6b92_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam_file), path(bai_file))

    output:
        tuple(val(sample_id), path("${bam_file.simpleName}.sam"))

    script:
        """
        sambamba view -h -t ${task.cpus} ${bam_file} > ${bam_file.simpleName}.sam
        """
}
