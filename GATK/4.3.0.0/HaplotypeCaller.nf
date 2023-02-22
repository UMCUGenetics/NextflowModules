process HaplotypeCaller {
    tag {"GATK HaplotypeCaller ${sample_id} - ${region}"}
    label 'GATK_4_3_0_0'
    label 'GATK_4_3_0_0_HaplotypeCaller'
    container = 'broadinstitute/gatk:4.3.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(analysis_id), path(bam_files), path(bai_files), path(interval_file))

    output:
        tuple(
            val(analysis_id),
            path("${analysis_id}.${interval_file.baseName}.vcf"),
            path("${analysis_id}.${interval_file.baseName}.vcf.idx"),
            emit: vcf_file
        )

    script:
        def input_files = bam_files.collect{"$it"}.join(" --input_file ")
        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" \
        HaplotypeCaller \
        --reference ${params.genome_fasta} \
        --input ${input_files} \
        --output ${analysis_id}.${interval_file.baseName}.vcf \
        --intervals ${interval_file} \
        $params.optional
        """
}