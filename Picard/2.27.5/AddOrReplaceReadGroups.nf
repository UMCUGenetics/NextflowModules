process AddOrReplaceReadGroups {
    tag {"PICARD AddOrReplaceReadGroups ${sample_id}"}
    label 'PICARD_2_27_5'
    label 'PICARD_2_27_5_AddOrReplaceReadGroups'
    container = 'quay.io/biocontainers/picard:2.27.5--hdfd78af_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam_file), path(bai_file))

    output:
        tuple(val(sample_id), val(sample_id), path("${sample_id}.RG.bam"), path("${sample_id}.RG.bai"), emit: readgroup_bams)

    script:
	//check if custom settings have been specified, otherwise use defaults
        """
        picard -Xmx${task.memory.toGiga()-4}G -Djava.io.tmpdir=\$TMPDIR AddOrReplaceReadGroups \
        TMP_DIR=\$TMPDIR \
        INPUT=${bam_file} \
        OUTPUT=${sample_id}.RG.bam \
        RGID=${sample_id} \
        RGLB=${sample_id} \
        RGPL=ILLUMINA \
        RGPU=XXXXYYY \
        RGSM=${sample_id}    

        picard -Xmx${task.memory.toGiga()-4}G -Djava.io.tmpdir=\$TMPDIR BuildBamIndex \
        TMP_DIR=\$TMPDIR \
        INPUT=${sample_id}.RG.bam
        """
}
