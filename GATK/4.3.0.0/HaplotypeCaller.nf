process HaplotypeCaller {
    tag {"GATK HaplotypeCaller ${sample_id}.${int_tag}"}
    label 'GATK_4_3_0_0'
    label 'GATK_4_3_0_0_HaplotypeCaller'
    container = 'broadinstitute/gatk:4.3.0.0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam), path(bai), path(interval_file))

    output:
        tuple(
            val(sample_id),
            val(int_tag),
            path("${sample_id}.${int_tag}.${ext_vcf}"),
            path("${sample_id}.${int_tag}.${ext_index}"),
            path(interval_file),
            emit: htcaller_vcfs
        )

    script:
        int_tag = interval_file.toRealPath().toString().split("/")[-2]
        ext = params.optional =~ /GVCF/ ? 'g.vcf' : 'vcf'

        ext_vcf = params.compress ? "${ext}.gz" : "${ext}"
        ext_index = params.compress ? "${ext}.gz.tbi" : "${ext}.idx"

        """
        gatk --java-options "-Xmx${task.memory.toGiga()-4}g -Djava.io.tmpdir=\$TMPDIR" HaplotypeCaller \
        --tmp-dir \$TMPDIR \
        ${params.optional} \
        -I $bam \
        --output ${sample_id}.${int_tag}.${ext_vcf} \
        -R $params.genome_fasta \
        -L $interval_file
        """
}
