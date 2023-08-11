process Freec {
    tag {"Control Freec ${sample_id}"}
    label 'ControlFreec_11_6'
    label 'ControlFreec_11_6_Freec'
    container = 'quay.io/biocontainers/control-freec:11.6--h87f3376_2'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam_file), path(bai_file))

    output:
        tuple(val(sample_id), path("${bam_file.name}_ratio.txt"), path("${bam_file.name}_CNVs"), emit: cnv)
        tuple(val(sample_id), path("${bam_file.name}_sample.cpn"), path("${bam_file.name}_ratio.BedGraph"), path("${bam_file.name}_info.txt"), emit: other)

    script:
        def config = "${sample_id}.config"
        """
        touch ${config}
        echo "[general]" >> ${config}
        echo "chrLenFile = ${params.chr_len_file}" >> ${config}
        echo "chrFiles = ${params.chr_files}" >> ${config}
        echo "gemMappabilityFile = ${params.gem_mappability_file}" >> ${config}
        echo "ploidy = ${params.ploidy}" >> ${config}
        echo "window = ${params.window}" >> ${config}
        echo "telocentromeric = ${params.telocentromeric}" >> ${config}
        echo "BedGraphOutput=TRUE" >> ${config}
        echo "maxThreads=${task.cpus}" >> ${config}

        echo "[sample]" >> ${config}
        echo "inputFormat = BAM" >> ${config}
        echo "mateFile = ${bam_file}" >> ${config}

        freec -conf ${config}
        """
}
