process NanopolishCallMethylation {
    tag {"NanopolishCallMethylation  ${fastq_id}"}
    label 'NanopolishCallMethylation_0_13_2'
    container = 'quay.io/biocontainers/nanopolish:0.13.2--h92fde30_9'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(fastq_id), path(bam_file), path(bai_file), path(fastq), path(index), path(fai), path(gzi), path(readdb))
  
    output:
        tuple(val(fastq_id), path("${bam_file.baseName}.csv"))

    script:
        // Note, HDF5_PLUGIN_PATH is image specific
        """
        export HDF5_PLUGIN_PATH=/usr/local/hdf5/lib/plugin/ 
        nanopolish call-methylation -t 8 -r ${fastq} -b ${bam_file} -g ${params.genome} > ${bam_file.baseName}.csv
        """
}
