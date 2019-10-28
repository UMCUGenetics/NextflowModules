
process CollectMultipleMetrics {
  tag {"CollectMultipleMetrics ${sample_id}"}
  label 'GATK'
  clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.collectmultiplemetrics_mem}" : ""
  publishDir "$params.out_dir/$sample_id/multiple_metrics", mode: 'copy'


  input:
    tuple sample_id, file(bam)

  output:
    file ("multiple_metrics*")

  script:
  """
  gatk --java-options -Xmx${task.memory.toGiga()-4}g \
  CollectMultipleMetrics \
  -I $bam \
  -O multiple_metrics\
  -R $params.genome_fasta \
  --PROGRAM CollectAlignmentSummaryMetrics \
  --PROGRAM CollectInsertSizeMetrics \
  --PROGRAM QualityScoreDistribution \
  --PROGRAM MeanQualityByCycle \
  --PROGRAM CollectBaseDistributionByCycle \
  --PROGRAM CollectGcBiasMetrics \
  --PROGRAM CollectSequencingArtifactMetrics \
  --PROGRAM CollectQualityYieldMetrics

  """
}
//--PROGRAM CollectAlignmentSummaryMetrics \
//--PROGRAM CollectInsertSizeMetrics \
//--PROGRAM QualityScoreDistribution \
//--PROGRAM MeanQualityByCycle \
//--PROGRAM CollectBaseDistributionByCycle \
//--PROGRAM CollectGcBiasMetrics \
//--PROGRAM CollectSequencingArtifactMetrics \
//--PROGRAM CollectQualityYieldMetrics
