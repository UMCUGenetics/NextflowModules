 process Lc_extrap {
      tag {"Preseq Lc_extrap ${sample_id} "}
      label 'Preseq_2_0_3'
      label 'Preseq_2_0_3_Lc_extrap'
      clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
      container = "/hpc/local/CentOS7/cog_bioinf/nextflow_containers/Preseq/Preseq_2.0.3_Samtools_1.9-squashfs-pack.gz.squashfs"
      shell = ['/bin/bash', '-euo', 'pipefail']

      input:
      tuple sample_id, file(bam), file(bai)

      output:
      tuple sample_id, file("${bam.baseName}.ccurve.txt") 

      script:
      //Adapted code from: https://github.com/nf-core/rnaseq - MIT License - Copyright (c) Phil Ewels, Rickard Hammarén
      """
      preseq lc_extrap ${params.optional} ${bam} -o ${bam.baseName}.ccurve.txt
      """
  }

