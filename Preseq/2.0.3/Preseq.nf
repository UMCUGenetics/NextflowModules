 process Preseq {
      tag {"Preseq ${sample_id} "}
      label 'Preseq_2_0_3'
      clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.preseq_mem}" : ""
      container = '/hpc/cog_bioinf/ubec/tools/rnaseq_containers/Preseq_2.0.3_Samtools_1.9-squashfs-pack.gz.squashfs'
      shell = ['/bin/bash', '-euo', 'pipefail']

      input:
      tuple sample_id, file(bam_input), file(bai_input)

      output:
      tuple sample_id, file("${bam_input.baseName}.ccurve.txt") 

      script:
      """
      preseq lc_extrap -v -B $bam_input -o ${bam_input.baseName}.ccurve.txt
      """
  }

