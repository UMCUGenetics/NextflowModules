process Fastp {
    tag {"Fastp ${sample_id} - ${rg_id}"}
    label 'Fastp_0_14_1'
    container = '/hpc/local/CentOS7/cog_bioinf/nextflow_containers/fastp/fastp_0.14.1-squashfs-pack.gz.squashfs'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.fastp_mem}" : ""
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, rg_id, file(reads)

    output:
    tuple sample_id, rg_id, file("${sample_id}_fastp.json"), file("*.fastq.gz")

    script:
    //adapted from https://github.com/nf-core/eager/blob/master/LICENSE, Copyright (c) Alexander Peltzer, Stephen Clayton, James A. Fellows Yates, Maxime Borry
    if (params.singleEnd) {
    """
    fastp --in1 ${reads[0]} --out1 "${reads[0].simpleName}.trim.fastq.gz" -j ${sample_id}_fastp.json $params.fastp.toolOptions
    """
    } else {
    """
    fastp --in1 ${reads[0]} --in2 ${reads[1]} --out1 "${reads[0].simpleName}.trim.fastq.gz" --out2 "${reads[1].simpleName}.trim.fastq.gz" -j ${sample_id}_fastp.json $params.fastp.toolOptions
    """
   }
}
