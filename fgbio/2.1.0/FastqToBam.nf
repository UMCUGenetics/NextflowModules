process FastqToBam {
  tag {"FGBIO FastqToBam ${sample_id}"}
  label 'FGBIO_2_1_0'
  label 'FGBIO_2_1_0_FastqToBam'
  // container = 'library://sawibo/default/bioinf-tools:idt-umi-dependencies'

  shell = ['/bin/bash', '-euo', 'pipefail']
  input:
  tuple (sample_id, flowcell, machine, run_nr, path(fastq))

  output:
  tuple (sample_id, flowcell, machine, run_nr, path("${sample_id}.unmapped.bam"), emit: unmapped_bams)

  script:
    // ext = params.optional =~ /GVCF/ ? '.g.vcf' : '.vcf'
  fgbio_exec = params.fgbio_exec
  """
  java -Xmx${task.memory.toGiga()-4}g -jar ${fgbio_exec} --compression 1 --async-io FastqToBam \
  --input ${fastq} \
  --read-structures ${params.read_structures} \
  --sample ${sample_id} \
  --library ${sample_id} \
  --platform-unit ${flowcell} \
  --output ${sample_id}.unmapped.bam

  """
}
