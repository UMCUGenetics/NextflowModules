process Fastp {
    tag {"fastp ${sample_id} - ${rg_id}"}
    label '0_14_1'
    label 'fastp_0_14_1'
    container = '/hpc/local/CentOS7/cog_bioinf/nextflow_containers/Salmon/0.13.1/salmon-0.13.1-squashfs-pack.gz.squashfs'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, rg_id, file(fastqs)

    output:
    tuple sample_id, rg_id, file("${sample_id}_fastp.json"), file("*.fastq.gz")

    script:
    def read_args = !params.singleEnd ? "-i ${reads[0]} -I ${reads[1]} -o {sample_id}_${rg_id)_trim_R1.fastq.gz -O {sample_id}_${rg_id)_trim.R2.fastq.gz" :"-i ${reads} -o {sample_id}_${rg_id)_trim_R1.fastq.gz"   
    //adapted from https://github.com/angelovangel/nextflow-fastp	    
    """
    fastp $read_args -j ${sample_id}_fastp.json ${params.fastp.toolOptions}
    """

}
