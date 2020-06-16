process ControlFreec {
    tag {"ControlFreec ${sample_id}"}
    label 'ControlFreec_11_5'
    //label 'Tool_verion_Command'
    container = '/hpc/cuppen/projects/TP0002_USEQ/general/analysis/sboymans/singularity/freec11.5.squashfs'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(bam_file),path(bai_file))

    output:
        tuple(sample_id, path("${config}"),path("${bam_file}_CNVs"),path("${bam_file}_ratio.txt"),path("${bam_file}_CNVs.p.value.txt"),path("${bam_file}_ratio.txt.log2.png"),path("${bam_file}_ratio.txt.png"),path("${bam_file}_ratio_karyotype.pdf"), emit: output_file)

    script:
      config = "${sample_id}_freec.config"
      """
      touch ${config}
      echo "[general]" >> ${config}
      echo "chrLenFile = ${params.genome_freec_chr_len}" >> ${config}
      printf "${params.optional}" >> ${config}
      echo "samtools = samtools" >> ${config}
      echo "sambamba = sambamba" >> ${config}
      echo "chrFiles = ${params.genome_freec_chr_files}" >> ${config}
      echo "maxThreads = ${task.cpus}" >> ${config}
      echo "outputDir = ." >> ${config}
      echo "gemMappabilityFile = ${params.genome_freec_mappability}" >> ${config}
      echo "[sample]" >> ${config}
      echo "mateFile = ${bam_file}" >> ${config}
      echo "inputFormat = BAM" >> ${config}
      echo "mateOrientation = FR" >> ${config}

      freec -conf ${config}

      cat /bin/assess_significance.R | R --slave --args ${bam_file}_CNVs ${bam_file}_ratio.txt
      cat /bin/makeGraph.R | R --slave --args 2 ${bam_file}_ratio.txt
      cat /bin/makeKaryotype.R | R --slave --args 2 4 500000 ${bam_file}_ratio.txt
      """
}
