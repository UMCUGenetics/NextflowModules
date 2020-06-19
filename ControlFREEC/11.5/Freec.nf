process Freec {
    tag {"Control Freec ${sample_id}"}
    label 'ControlFreec_11_5'
    label 'ControlFreec_11_5_Freec'
    //TODO: upload to singularity library
    container = 'library://sawibo/default/bioinf-tools:freec11.5'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(bam_file), path(bai_file))

    output:
        tuple(sample_id, path("${bam_file.name}_ratio.txt"), path("${bam_file.name}_CNVs"), emit: cnv)
        tuple(sample_id, path("${bam_file.name}_sample.cpn"), path("${bam_file.name}_ratio.BedGraph"), path("${bam_file.name}_info.txt"), emit: other)

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
