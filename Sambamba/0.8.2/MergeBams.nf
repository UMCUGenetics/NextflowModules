process MergeBams {
    tag {"Sambamba MergeBams ${sample_id}"}
    label 'Sambamba_0_8_2'
    label 'Sambamba_0_8_2_MergeBams'
    container = 'quay.io/biocontainers/sambamba:0.8.2--h98b6b92_2'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bams), path(bais))

    output:
        tuple(val(sample_id), path("${sample_id}_${ext}"), path("${sample_id}_${ext}.bai"), emit: merged_bams)

    script:
        ext = bams[0].toRealPath().toString().split("_")[-1]

        """
        sambamba merge -t ${task.cpus} ${sample_id}_${ext} ${bams}
        sambamba index -t ${task.cpus} ${sample_id}_${ext} ${sample_id}_${ext}.bai
        """
}
