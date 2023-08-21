process LongshotPhase {
    tag {"LongshotPhase ${bam_file}"}
    label 'LongshotPhase_0_4_1'
    container = 'quay.io/biocontainers/longshot:0.4.1--hc4ca7c3_2'
    shell = ['/bin/bash', '-euo', 'pipefail']
    
    input:
        tuple(path(bam_file), path(bai_file))
    
    output:
        tuple (path("${bam_file.simpleName}_phased.bam"), path("${bam_file.simpleName}_phased.vcf"))

    script:
        """
        longshot --out_bam ${bam_file.simpleName}_phased.bam --bam ${bam_file} --ref ${params.genome_fasta} --out ${bam_file.simpleName}_phased.vcf $params.longshotparams > ${bam_file.simpleName}.out
        """
}
