 process Preseq {
      tag {"Preseq ${sample_id} "}
      label 'Preseq_2_0_3'
      clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.preseq_mem}" : ""
      shell = ['/bin/bash', '-euo', 'pipefail']

      input:
      tuple sample_id, file(bams), file(bais)

      output:
      tuple sample_id, file("${bams.baseName}.ccurve.txt") 

      script:
      //Adapted code from: https://github.com/nf-core/rnaseq - MIT License - Copyright (c) Phil Ewels, Rickard Hammarén
      """
      preseq lc_extrap -v -B $bams -o ${bams.baseName}.ccurve.txt
      """
  }

