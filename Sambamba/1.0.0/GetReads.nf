process GetReadIDs {
    tag {"Sambamba GetReadIDs ${sample_id}"}
    label 'Sambamba_1_0_0_GetReadIDs'
    container = 'quay.io/biocontainers/sambamba:1.0--h98b6b92_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam_file), path(bai_file))

    output:
        tuple(val(sample_id), path("${bam_file.simpleName}_reads.txt"))

    script:
        """
        sambamba view -t ${task.cpus} ${bam_file} | cut -f1 | sort | uniq > ${bam_file.simpleName}_reads.txt
        """
}
