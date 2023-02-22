process GroupBamByUmi {
    tag {"FGBIO GroupBamByUmi ${sample_id}"}
    label 'FGBIO_2_1_0'
    label 'FGBIO_2_1_0_GroupBamByUmi'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    // container = 'library://sawibo/default/bioinf-tools:idt-umi-dependencies'

    shell = ['/bin/bash', '-euo', 'pipefail']
    input:
      tuple (sample_id, flowcell, machine, run_nr, path(bam))

    output:
      tuple (sample_id, flowcell, machine, run_nr, path("${sample_id}.grouped.bam"), path("${sample_id}.tag-family-sizes.txt"), emit : grouped_bams)

    script:
    fgbio_exec = params.fgbio_exec
    """
      java -Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$PWD -jar ${fgbio_exec} --compression 1 --async-io GroupReadsByUmi \
    --input ${bam} \
    --strategy Adjacency \
    --edits 1 \
    --output ${sample_id}.grouped.bam \
    --family-size-histogram ${sample_id}.tag-family-sizes.txt

    """
}
