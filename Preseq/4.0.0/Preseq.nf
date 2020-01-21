 process preseq {
      tag {"Preseq ${sample_id} "}
      label 'Preseq_4_0_0'
      container = '/hpc/cog_bioinf/ubec/tools/rnaseq_containers/preseq_4.0.0-squashfs-pack.gz.squashfs'
      shell = ['/bin/bash', '-euo', 'pipefail']

      input:
      tuple sample_id, file(bam_input)

      output:
      tuple sample_id, file("${bam_input.baseName}.ccurve.txt") 

      script:
      """
      preseq lc_extrap -v -B $bam_input -o ${bam_input.baseName}.ccurve.txt
      """
  }

