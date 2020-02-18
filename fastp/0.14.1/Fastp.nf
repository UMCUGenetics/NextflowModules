process Fastp {
    tag {"fastp ${sample_id} - ${rg_id}"}
    label 'fastp_0_14_1'
    container = '/hpc/local/CentOS7/cog_bioinf/nextflow_containers/fastp/fastp_0.14.1-squashfs-pack.gz.squashfs'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.fastp_mem}" : ""
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, rg_id, file(reads)

    output:
    tuple sample_id, rg_id, file("${sample_id}_fastp.json"), file("*.fastq.gz")

    script:
    if (params.singleEnd) {
    """
    fastp --in1 ${reads[0]} --out1 ${sample_id}_${rg_id}.trim_R1.fastq.gz -j ${sample_id}_fastp.json $params.fastp.toolOptions
    """
    } else {
    """
    fastp --in1 ${reads[0]} --in2 ${reads[1]} --out1 "${reads[0].baseName}.trim.R1.fastq.gz" --out2 "${reads[1].baseName}.trim.R2.fastq.gz -j ${sample_id}_fastp.json $params.fastp.toolOptions
    """
   }
}
