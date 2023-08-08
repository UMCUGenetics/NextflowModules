
process SplitNCigarReads {
    tag {"GATK SplitNCigarReads ${sample_id}"}
    label 'GATK_4_1_3_0'
    label 'GATK_4_1_3_0_SplitNCigarReads'
    container = 'library://sawibo/default/bioinf-tools:gatk4.1.3.0'
    shell = ['/bin/bash', '-euo', 'pipefail']
    input:
        tuple(val(sample_id), path(bam_file), path(bai_file))

    output:
        tuple(val(sample_id), path("${sample_id}.split.bam"), path("${sample_id}.split.bai"), emit: bam_file)

    script:
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
        SplitNCigarReads \
        --tmp-dir \$TMPDIR \
        -R ${params.genome_fasta} \
        -I ${bam_file} \
        --refactor-cigar-string \
        -O ${sample_id}.split.bam
        """
}
