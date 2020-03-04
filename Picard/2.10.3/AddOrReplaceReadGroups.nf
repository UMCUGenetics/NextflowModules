process AddOrReplaceReadGroups {
    tag {"Picard AddOrReplaceReadGroups ${sample_id} - ${rg_id} "}
    label '2_10_3'
    label 'Picard_2_10_3_AddOrReplaceReadGroups'
    container = '/hpc/local/CentOS7/cog_bioinf/nextflow_containers/picard_2.10.3-squashfs-pack.gz.squashfs'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, rg_id, file(bam), file(bai)

    output:
    tuple sample_id, file("${sample_id}.rg.bam")


    script:
    def barcode = rg_id.split('_')[1]
    
    """
    java-picard AddOrReplaceReadGroups \
      I=$bam \
      O=$sample_id.rg.bam \
      RGID=$rg_id \
      RGLB=$sample_id \
      RGPL=ILLUMINA \
      RGPU=$barcode \
      RGSM=$sample_id
    """

}
