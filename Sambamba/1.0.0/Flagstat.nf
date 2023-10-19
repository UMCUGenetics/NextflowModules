process Flagstat {
    tag {"Sambamba Flagstat ${sample_id}"}
    label 'Sambamba_1_0_0'
    label 'Sambamba_1_0_0_Flagstat'
    container = 'quay.io/biocontainers/sambamba:1.0--h98b6b92_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam_file), path(bai_file))

    output:
        path("${bam_file.baseName}.flagstat", emit: flagstat)

    script:
        """
        sambamba flagstat -t ${task.cpus} ${bam_file} > ${bam_file.baseName}.flagstat
        """
}
