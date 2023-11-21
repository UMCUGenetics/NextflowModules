process AddReplaceReadgroup {
    tag {"Samtools AddReplaceReadgroup ${bam_file}"}
    label 'Samtools_1_15'
    label 'Samtools_1_15_AddReplaceReadgroup'
    container = 'quay.io/biocontainers/samtools:1.15.1--h1170115_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        val(sample_id)
        tuple(path(bam_file), path(bai_file))

    output:
        path("${bam_file.baseName}_rg.bam", emit: bam_rg_file)

    script:
        readgroup = "\"@RG\\tID:${bam_file.simpleName}\\tSM:${sample_id}\\tPL:ONT\\tLB:${sample_id}\""
        """
        samtools addreplacerg -w -r $readgroup ${bam_file} -o ${bam_file.baseName}_rg.bam --output-fmt BAM 
        """
}
