process Flagstat {
    tag {"Sambamba Flagstat ${sample_id}"}
    label 'Sambamba_0_8_2'
    label 'Sambamba_0_8_2_Flagstat'
    container = 'quay.io/biocontainers/sambamba:0.8.2--h98b6b92_2'
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
