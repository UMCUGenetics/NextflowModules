process MergeBams {
  tag {"Sambamba MergeBams ${sample_id}"}
  label 'Sambamba_0_6_8_MergeBams'
  clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
  container = 'library://sawibo/default/bioinf-tools:sambamba-0.6.8'
  shell = ['/bin/bash', '-euo', 'pipefail']
  input:
    tuple (sample_id, path(bams), path(bais))

  output:
    tuple (sample_id, path("${sample_id}_${ext}"), path("${sample_id}_${ext}.bai"), emit: merged_bams)

  script:
    ext = bams[0].toRealPath().toString().split("_")[-1]

    """
    sambamba merge -t ${task.cpus} ${sample_id}_${ext} ${bams}
    sambamba index -t ${task.cpus} ${sample_id}_${ext} ${sample_id}_${ext}.bai
    """
}
