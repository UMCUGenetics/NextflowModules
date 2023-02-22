process MapBam {
    tag {"FGBIO MapBam ${sample_id}"}
    label 'FGBIO_2_1_0'
    label 'FGBIO_2_1_0_MapBam'
    clusterOptions = workflow.profile == "sge" ? "-l h_vmem=${params.mem}" : ""
    // container = 'library://sawibo/default/bioinf-tools:idt-umi-dependencies'


    shell = ['/bin/bash', '-euo', 'pipefail']
    input:
      tuple (sample_id, flowcell, machine, run_nr, path(bam))

    output:
      tuple (sample_id, flowcell, machine, run_nr, path("${sample_id}.mapped.bam"), emit: mapped_bams)

    script:
    fgbio_exec = params.fgbio_exec
    samtools_exec = params.samtools_exec
    bwa_exec = params.bwa_exec
    """
    ${samtools_exec} fastq ${bam} \
    | ${bwa_exec} mem -t ${task.cpus} -p -K 150000000 -Y ${params.genome_fasta} - \
    | java -Xmx${task.memory.toGiga()-4}g -jar ${fgbio_exec} --compression 1 --async-io ZipperBams \
      --unmapped ${bam} \
      --ref ${params.genome_fasta} \
      --output ${sample_id}.mapped.bam

    """
}
