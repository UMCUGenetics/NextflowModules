
process VariantFiltration {
    tag {"VariantFiltration ${run_id}.${interval}.${type}"}
    label 'GATK'
    container = '/hpc/cog_bioinf/cuppen/personal_data/sander/scripts/Nextflow/Singularity-images/gatk4.1.3.0.squashfs'

    //publishDir "$params.out_dir/vcf/", mode: 'copy'

    memory '4 GB'
    time '4h'

    input:
      tuple run_id, interval, type, file(vcf), file(vcfidx), file(interval_file)

    output:
      tuple run_id, interval, type, file("${run_id}.${interval}.${type}.filtered_variants.vcf"), file("${run_id}.${interval}.${type}.filtered_variants.vcf.idx")

    script:
    if (type == 'SNP'){
      filter_criteria = "-filter 'QD < 2.0' -filter 'ReadPosRankSum < -20.0' -filter 'FS > 200.0' --filterName 'INDEL_LowQualityDepth' --filterName 'INDEL_ReadPosRankSumLow' --filterName 'INDEL_StrandBias'"
    }else{

    }
    """
    gatk --java-options -Xmx${task.memory.toGiga()-4}g \
    VariantFiltration \
    -R $params.genome_fasta \
    -V $vcf \
    -O ${run_id}.${interval}.${type}.filtered_variants.vcf \
    $filter_criteria
    """
}


///gnu/store/1hykmyl04mhvrwd5qrz88ymamj7nhc1p-icedtea-3.7.0/bin/java -Xmx10G \
//    -Djava.io.tmpdir=/hpc/cog_bioinf/cuppen/processed_data/external/HMFreg0528_UMCU-002-USEQ065/output/tmp \
//    -jar /gnu/store/3fqyf31lxc7rcvmwmzmz9xvjfck695rv-gatk-queue-3.8/share/java/gatk/Queue.jar \
//    -jobQueue all.q \
//    -jobNative " -m as -M R.R.E.Janssen-10@umcutrecht.nl -V -P cog_bioinf -pe threaded 1 -q all.q -l h_rt=24:0:0 -m as -M R.R.E.Janssen-10@umcutrecht.nl -l h_vmem=15G" \
//    -jobRunner GridEngine \
//    -jobReport /hpc/cog_bioinf/cuppen/processed_data/external/HMFreg0528_UMCU-002-USEQ065/output/logs/GermlineFilter.jobReport.txt \
//    -S /hpc/cog_bioinf/cuppen/processed_data/external/HMFreg0528_UMCU-002-USEQ065/output/QScripts/GermlineFilter.scala \
//    -R /hpc/cog_bioinf/GENOMES/Homo_sapiens.GRCh37.GATK.illumina/Homo_sapiens.GRCh37.GATK.illumina.fasta \
//    -V /hpc/cog_bioinf/cuppen/processed_data/external/HMFreg0528_UMCU-002-USEQ065/output/output.raw_variants.vcf \
//    -O output \
//    -mem 10 \
//    -nsc 12 \
//    -snpType SNP \
//    -snpType NO_VARIATION \
//    -snpFilterName SNP_HaplotypeScoreHigh \
//    -snpFilterExpression "HaplotypeScore > 13.0" \
//    -snpFilterName SNP_LowQualityDepth \
//    -snpFilterExpression "QD < 2.0" \
//    -snpFilterName SNP_MQRankSumLow \
//    -snpFilterExpression "MQRankSum < -12.5" \
//    -snpFilterName SNP_MappingQuality \
//    -snpFilterExpression "MQ < 40.0" \
//    -snpFilterName SNP_ReadPosRankSumLow \
//    -snpFilterExpression "ReadPosRankSum < -8.0" \
//    -snpFilterName SNP_StrandBias \
//    -snpFilterExpression "FS > 60.0" \
//    -cluster 3 \
//    -window 35 \
//    -indelType INDEL \
//    -indelType MIXED \
//    -indelFilterName INDEL_LowQualityDepth \
//    -indelFilterExpression "QD < 2.0" \
//    -indelFilterName INDEL_ReadPosRankSumLow \
//    -indelFilterExpression "ReadPosRankSum < -20.0" \
//    -indelFilterName INDEL_StrandBias \
//    -indelFilterExpression "FS > 200.0" \
//    -run
