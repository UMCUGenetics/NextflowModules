process Filter_ROI {
    tag {"Sambamba Filter_ROI ${bam_file}"}
    label 'Sambamba_0_7_0_Filter_ROI'
    container = 'quay.io/biocontainers/sambamba:0.7.0--h89e63da_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(path(bam_file))

    output:
        tuple(path("${bam_file.simpleName}_roi.bam"), path("${bam_file.simpleName}_roi.bam.bai"))

    script:
        roi_slice = ""
        if( params.roi )
            roi_slice = " $params.roi "
        """
        sambamba view -t ${task.cpus} -f bam ${bam_file} $roi_slice -o  ${bam_file.simpleName}_roi.bam
        """
}

process Filter_Condition {
    tag {"Sambamba Filter Condition ${bam_file}"}
    label 'Sambamba_0_7_0_Filter_Condition'
    container = 'quay.io/biocontainers/sambamba:0.7.0--h89e63da_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(path(bam_file))

    output:
        tuple(path("${bam_file.simpleName}_condition.bam"), path("${bam_file.simpleName}_condition.bam.bai"))

    script:
        """
        sambamba view -t ${task.cpus} -f bam -F "${params.conditions}" ${bam_file} -o  ${bam_file.simpleName}_condition.bam
        """
}
