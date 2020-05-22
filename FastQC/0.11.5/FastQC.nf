process FastQC {
    tag {"FastQC ${sample_id} - ${rg_id}"}
    label 'FastQC_0_11_5'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:fastqc-0.11.5'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple (sample_id, rg_id, path(fastq) )

    output:
        path("*_fastqc.{zip,html}", emit: fastqc_reports)

    script:
        """
        fastqc ${params.optional} -t ${task.cpus} $fastq
        """
}
