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
      """
      preseq lc_extrap -v -B $bams -o ${bams.baseName}.ccurve.txt
      """
  }

