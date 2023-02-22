process MakeUMIBam {
  tag {"bash MakeUMIBam ${sample_id}"}
  label 'bash_4_2_46'
  label 'bash_4_2_46_MakeUMIBam'
  // container = 'library://sawibo/default/bioinf-tools:idt-umi-dependencies'
  shell = ['/bin/bash', '-euo', 'pipefail']
  input:
  tuple (sample_id, flowcell, machine, run_nr, path(fastq))

  output:
  tuple (sample_id, flowcell, machine, run_nr, path("${sample_id}.u.grouped.bam"), emit: umi_bams)

  script:
  """
    . ${params.scripts}/env/bin/activate
    python ${params.scripts}/make_umi_bam.py ${sample_id} ${flowcell} ${machine} ${run_nr} "${fastq}"
  """
}
