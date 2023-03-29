process Mosdepth {
    tag {"Mosdepth ${sample_id}"}
    label 'Mosdepth_0_3_3'
    container = 'quay.io/biocontainers/mosdepth:0.3.3--h37c5b7d_2'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam_file), path(bai_file))

    output:
        path("${sample_id}.mosdepth.*.txt", emit: txt_files)
        path("${sample_id}*bed*", emit: bed_files, optional: true)

    script:
        """
        mosdepth -t ${task.cpus} ${params.optional} ${sample_id} ${bam_file}
        """
}