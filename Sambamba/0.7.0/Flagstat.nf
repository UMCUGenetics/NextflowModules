process Flagstat {
    tag {"Sambamba Flagstat ${sample_id}"}
    label 'Sambamba_0_7_0'
    label 'Sambamba_0_7_0_Flagstat'
    container = 'quay.io/biocontainers/sambamba:0.7.0--h89e63da_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(bam_file), path(bai_file))

    output:
        path("${bam_file.baseName}.flagstat", emit: flagstat)

    script:
        """
        sambamba flagstat -t ${task.cpus} ${bam_file} > ${bam_file.baseName}.flagstat
        """
}
