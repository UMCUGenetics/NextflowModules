process VariantFiltration {
    tag {"GATK VariantFiltration ${run_id}.${interval}.${type}"}
    label 'GATK_4_1_3_0'
    label 'GATK_4_1_3_0_VariantFiltration'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:gatk4.1.3.0'
    shell = ['/bin/bash', '-euo', 'pipefail']
    input:
        tuple (run_id, interval, type, path(vcf), path(vcfidx))

    output:
        tuple (run_id, interval, type, path("${run_id}.${interval}.${type}.filtered_variants.vcf"), path("${run_id}.${interval}.${type}.filtered_variants.vcf.idx"), emit: filtered_vcfs)

    script:
        if (type == 'SNP'){
          filter_criteria = "--filter-expression 'QD < 2.0' --filter-expression 'MQ < 40.0' --filter-expression 'FS > 60.0' --filter-expression 'HaplotypeScore > 13.0' --filter-expression 'MQRankSum < -12.5' --filter-expression 'ReadPosRankSum < -8.0' --filter-expression 'MQ0 >= 4 && ((MQ0 / (1.0 * DP)) > 0.1)' --filter-expression 'DP < 5' --filter-expression 'QUAL < 30' --filter-expression 'QUAL >= 30.0 && QUAL < 50.0' --filter-expression 'SOR > 4.0' --filter-name 'SNP_LowQualityDepth' --filter-name 'SNP_MappingQuality' --filter-name 'SNP_StrandBias' --filter-name 'SNP_HaplotypeScoreHigh' --filter-name 'SNP_MQRankSumLow' --filter-name 'SNP_ReadPosRankSumLow' --filter-name 'SNP_HardToValidate' --filter-name 'SNP_LowCoverage' --filter-name 'SNP_VeryLowQual' --filter-name 'SNP_LowQual' --filter-name 'SNP_SOR' -cluster 3 -window 10"
        } else if (type == 'RNA') {
           filter_criteria = "--filter-name 'FS' --filter-expression 'FS > 30.0' --filter-name 'QD' --filter-expression 'QD < 2.0'"
        } else {
           filter_criteria = "--filter-expression 'QD < 2.0' --filter-expression 'ReadPosRankSum < -20.0' --filter-expression 'FS > 200.0' --filter-name 'INDEL_LowQualityDepth' --filter-name 'INDEL_ReadPosRankSumLow' --filter-name 'INDEL_StrandBias'"
        }
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
        VariantFiltration \
        ${params.optional} \
        -R $params.genome_fasta \
        -V $vcf \
        -O ${run_id}.${interval}.${type}.filtered_variants.vcf \
        --tmp-dir \$TMPDIR \
        $filter_criteria
        """
}
