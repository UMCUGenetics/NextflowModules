
process SamToFastq {
    tag {"GATK_Samtofastq ${sample_id}.${int_tag}"}
    label 'GATK_4_1_3_0'
    label 'GATK_4_1_3_0_Samtofastq'

    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.samtofastq.mem}" : ""
    container = 'library://sawibo/default/bioinf-tools:gatk4.1.3.0'

    // publishDir params.out_dir, mode: 'copy'
    input:
      tuple sample_id, flowcell, machine, run_nr,file(bam)

    output:
      tuple sample_id, flowcell, machine, run_nr,file("*.fastq.gz")

    script:

    """
    gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
    SamToFastq  \
    ${params.samtofastq.toolOptions} \
    --INPUT $bam \
    --FASTQ ${sample_id}_${flowcell}_R1.fastq.gz \
    --SECOND_END_FASTQ ${sample_id}_${flowcell}_R2.fastq.gz \
    --INCLUDE_NON_PF_READS true \
    """
}
//--OUTPUT_PER_RG true \
// --FASTQ ${sample_id}_R1.fastq.gz \
// --SECOND_END_FASTQ ${sample_id}_R2.fastq.gz \
// --COMPRESS_OUTPUTS_PER_RG true \
// java -Xmx5G -Djava.io.tmpdir=/hpc/cog_bioinf/cuppen/personal_data/sander/tmp/ -jar /hpc/local/CentOS7/cog_bioinf/picard-tools-2.5.0/picard.jar \
// SamToFastq I=/hpc/cog_bioinf/cuppen/personal_data/sander/scripts/Nextflow/output/umi-test/S3-100ng-6cyc-S3.u.consensus.bam \
// FASTQ=/hpc/cog_bioinf/cuppen/personal_data/sander/scripts/Nextflow/output/umi-test/S3-100ng-6cyc-S3_R1.fastq.gz SECOND_END_FASTQ=/hpc/cog_bioinf/cuppen/personal_data/sander/scripts/Nextflow/output/umi-test/S3-100ng-6cyc-S3_R2.fastq.gz INCLUDE_NON_PF_READS=false

// ID:0gray_H3HM3AFX2_1    LB:0gray        PL:ILLUMINA     PU:H3HM3AFX2    SM:0gray

//NS500414:682:H3HM3AFX2:3:21412:5864:10124
