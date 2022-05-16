process GetReadIDs {
    tag {"Sambamba GetReadIDs ${sample_id}"}
    label 'Sambamba_0_7_0_GetReadIDs'
    container = 'quay.io/biocontainers/sambamba:0.7.0--h89e63da_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(bam_file), path(bai_file))

    output:
        tuple(sample_id, path("${bam_file.simpleName}_reads.txt"))

    script:
        """
        sambamba view -t ${task.cpus} ${bam_file} | cut -f1 | sort | uniq > ${bam_file.simpleName}_reads.txt
        """
}
