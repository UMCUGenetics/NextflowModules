process Freec {
    tag {"Control Freec ${sample_id}"}
    label 'ControlFreec_11_5'
    label 'ControlFreec_11_5_Freec'
    container = 'quay.io/biocontainers/control-freec:11.5--he1b5a44_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(bam_file), path(bai_file))

    output:
        tuple(sample_id, path("${bam_file.name}_ratio.txt"), path("${bam_file.name}_CNVs"), emit: cnv)
        tuple(sample_id, path("${bam_file.name}_sample.cpn"), path("${bam_file.name}_ratio.BedGraph"), path("${bam_file.name}_info.txt"), emit: other)

    script:
        """
        freec -conf ${params.config} -sample ${bam_file}
        """
}
