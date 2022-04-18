process NanopolishCallMethylation {
    tag {"NanopolishCallMethylation  ${fastq_id}"}
    label 'NanopolishCallMethylation_0_13_2'
    container = 'quay.io/biocontainers/nanopolish:0.13.2--h92fde30_9'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(fastq_id), path(bam_file), path(bai_file), path(fastq), path(index), path(fai), path(gzi), path(readdb))
  
    output:
        val(fastq_id)

    script:
        """
        export ${params.hfd5_plugin_path}
        nanopolish call-methylation -t 8 -r ${fastq} -b ${bam_file} -g ${params.genome} > ${bam_file.baseName}.csv
        """
}
