process Subsample {
    tag {"Sambamba Subsample ${sample_id}"}
    label 'Sambamba_1_0_0'
    label 'Sambamba_1_0_0_ViewSubsample'
    container = 'quay.io/biocontainers/sambamba:1.0--h98b6b92_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), val(fraction), path(bam_file), path(bai_file))

    output:
        tuple(val(sample_id), path("${bam_file.baseName}.subsample.bam"), path("${bam_file.baseName}.subsample.bam.bai"), emit: bam_file)

    script:
        """
        sambamba view -t ${task.cpus} -f bam -s ${fraction} ${params.optional} ${bam_file} -o ${bam_file.baseName}.subsample.bam
        """
}
