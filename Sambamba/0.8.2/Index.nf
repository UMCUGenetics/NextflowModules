process Index {
    tag {"Sambamba Index ${sample_id}"}
    label 'Sambamba_0_8_2'
    label 'Sambamba_0_8_2_Index'
    container = 'quay.io/biocontainers/sambamba:0.8.2--h98b6b92_2'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam_file))

    output:
        tuple(val(sample_id), path("${bam_file}.bai"), emit: bai_file)

    script:
        """
        sambamba index -t ${task.cpus} ${bam_file} ${bam_file}.bai
        """
}
