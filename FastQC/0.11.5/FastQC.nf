process FastQC {
    tag {"FastQC ${sample_id} - ${rg_id}"}
    label 'FASTQC_0_11_5'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.fastqc_mem}" : ""
    container = '/hpc/local/CentOS7/cog_bioinf/nextflow_containers/FastQC/fastqc-0.11.5.squashfs'
    shell = ['/bin/bash', '-euo', 'pipefail']
    	
    input:
    tuple sample_id, rg_id, file(fastq: "*")

    output:
    file "*_fastqc.{zip,html}"

    script:
    """
    fastqc -t ${task.cpus} $fastq
    """
}
