process FilterVcfs {
    tag {"GATK FilterVCFs ${sample_id}"}
    label 'GATK_4_2_1_0'
    label 'GATK_4_2_1_0_MergeVcfs'
    container = 'broadinstitute/gatk:4.2.1.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam_file), path(bai_file), path(vcf_files), path(vcf_index), val(ploidy))
        
    output:
        tuple (val(sample_id), path(bam_file), path(bai_file), "${sample_id}_snv.vcf", ploidy)              
        
    script:
        def input_files = vcf_files.collect{"$it"}.join(" --V ")
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}G" SelectVariants \
            --reference $params.genome \
            -V ${input_files} \
            --select-type-to-include $params.filter \
            -O ${sample_id}_snv.vcf
        """
}
