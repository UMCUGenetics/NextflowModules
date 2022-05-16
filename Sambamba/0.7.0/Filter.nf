process Filter {
    tag {"Sambamba Filter ${sample_id}"}
    label 'Sambamba_0_7_0_Filter'
    container = 'quay.io/biocontainers/sambamba:0.7.0--h89e63da_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(bam_file), path(bai_file))

    output:
        tuple(sample_id, path("${bam_file.simpleName}_roi.bam"), path("${bam_file.simpleName}_roi.bam.bai"))

    script:
        roi_slice = ""
        if( params.roi )
            roi_slice = " -L $params.roi "
        """
        sambamba view -h $roi_slice -t ${task.cpus} -f bam ${bam_file} -o  ${bam_file.simpleName}_roi.bam
        """
}
