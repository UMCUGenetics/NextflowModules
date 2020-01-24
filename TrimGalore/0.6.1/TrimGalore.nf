process TrimGalore {
    tag {"TrimGalore ${sample_id} - ${rg_id}"}
    label 'TrimGalore_0_6_1'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.trim_galore_mem}" : ""
    container = "/hpc/local/CentOS7/cog_bioinf/nextflow_containers/TrimGalore/trim-galore_0.6.1-squashfs-pack.gz.squashfs"
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, rg_id, file(fastqs)

    output:
    tuple sample_id, rg_id, file("*fq.gz"), file("*trimming_report.txt"), file( "*_fastqc.{zip,html}") 

    script:
    def paired = !params.singleEnd ? "--paired" :""   	
    """
    trim_galore $fastqs $paired --fastqc --gzip 
    """
}
