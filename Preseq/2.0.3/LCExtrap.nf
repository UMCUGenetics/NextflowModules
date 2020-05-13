 process LCExtrap {
      tag {"Preseq LCExtrap ${sample_id} "}
      label 'Preseq_2_0_3'
      label 'Preseq_2_0_3_LCExtrap'
      container = "quay.io/biocontainers/preseq:2.0.3--hf53bd2b_3"
      shell = ['/bin/bash', '-euo', 'pipefail']

      input:
        tuple(sample_id, path(bam), path(bai))

      output:
        tuple(sample_id, path("${bam.baseName}.ccurve.txt") , emit: preseqc_ccurve)

      script:
      //Adapted code from: https://github.com/nf-core/rnaseq - MIT License - Copyright (c) Phil Ewels, Rickard Hammarén
      """
      preseq lc_extrap ${params.optional} ${bam} -o ${bam.baseName}.ccurve.txt
      """
  }

