process Fastp {
    tag {"fastp ${sample_id} - ${rg_id}"}
    label 'fastp_0_14_1'
    container = '/hpc/local/CentOS7/cog_bioinf/nextflow_containers/Salmon/0.13.1/salmon-0.13.1-squashfs-pack.gz.squashfs'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, rg_id, file(fastqs)

    output:
    tuple sample_id, rg_id, file("${sample_id}_fastp.json"), file("*.fastq.gz")

    script:

    def r1_trim_out = {sample_id}_${rg_id)_trim_R1.fastq.gz
    def r2_trim_out = {sample_id}_${rg_id)_trim_R2.fastq.gz 
    def read_args = !params.singleEnd ? "-i ${reads[0]} -I ${reads[1]} -o $r1_trim_out -O $r2_trim_out" :"-i ${reads} -o $r1_trim"   
    //adapted from https://github.com/angelovangel/nextflow-fastp	    
    """
    fastp $read_args -j ${sample_id}_fastp.json ${params.fastp.toolOptions}
    """

}
