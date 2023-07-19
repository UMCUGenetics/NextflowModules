process IndexFeatureFile {
    tag {"GATK IndexFeatureFile ${identifier}"}
    label 'GATK_4_2_1_0'
    label 'GATK_4_2_1_0_IndexFeatureFile'
    container = 'broadinstitute/gatk:4.2.1.0'
    shell = ['/bin/bash', '-euo', 'pipefail']
    
    input:
        tuple(val(identifier), path(vcf_file))

    output:
        tuple(
            val(identifier), 
            path("${vcf_file}"), 
            path("${vcf_file}${ext_vcf_index}"), 
            emit: vcf_file
        )

    script:
        ext_vcf_index = vcf_file.getExtension() == ".gz" ? ".tbi" : ".idx"
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}G" IndexFeatureFile \
            --input ${vcf_file} \
            --output ${vcf_file}${ext_vcf_index} \
            --tmp-dir \$TMPDIR
        """
}