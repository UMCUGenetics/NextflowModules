process ApplyBQSR {
    tag {"GATK ApplyBQSR ${sample_id} - ${chr}"}
    label 'GATK_4_3_0_0'
    label 'GATK_4_3_0_0_ApplyBQSR'
    container = 'broadinstitute/gatk:4.3.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam_file), path(bai_file), val(chr), path(recalibration_report))

    output:
        tuple(val(sample_id), path("${bam_file.baseName}.bqsr.${chr}.bam"), path("${bam_file.baseName}.bqsr.${chr}.bai"), emit: bam_file)

    script:
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
        ApplyBQSR \
        --reference ${params.genome_fasta} \
        --input ${bam_file} \
        --use-original-qualities \
        --output ${bam_file.baseName}.bqsr.${chr}.bam \
        --bqsr-recal-file ${recalibration_report} \
        --intervals ${chr}
        """
}
