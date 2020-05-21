process STARFusion {
    tag {"STARFusion ${sample_id}"}
    label 'STARFusion_1_8_1'
    container = 'quay.io/biocontainers/star-fusion:1.8.1--2'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(fastq_files)) 
        path(star_index)
        path(genome_lib)

    output:
        tuple(sample_id, path("${sample_id}_star-fusion.tsv"), emit: fusion_predictions) 
        path("*.{tsv,txt}", emit: fusion_abridged)


    script:
        //Adapted code from: https://github.com/nf-core/rnafusion - MIT License - Copyright (c) Martin Proks
        def avail_mem = task.memory ? "--limitGenomeGenerateRAM ${task.memory.toBytes() - 100000000}" : ''
        def read_args = params.singleEnd ? "--left_fq ${fastq_files[0]}" : "--left_fq ${fastq_files[0]} --right_fq ${fastq_files[1]}"
        """
        STAR \
            --genomeDir ${star_index} \
            --readFilesIn ${fastq_files} \
            --twopassMode Basic \
            --outReadsUnmapped None \
            --chimSegmentMin 12 \
            --chimJunctionOverhangMin 12 \
            --alignSJDBoverhangMin 10 \
            --alignMatesGapMax 100000 \
            --alignIntronMax 100000 \
            --chimSegmentReadGapMax 3 \
            --alignSJstitchMismatchNmax 5 -1 5 5 \
            --runThreadN ${task.cpus} \
            --outSAMstrandField intronMotif ${avail_mem} \
            --outSAMunmapped Within \
            --outSAMtype BAM Unsorted \
            --outSAMattrRGline ID:GRPundef \
            --chimMultimapScoreRange 10 \
            --chimMultimapNmax 10 \
            --chimNonchimScoreDropMin 10 \
            --peOverlapNbasesMin 12 \
            --peOverlapMMp 0.1 \
            --readFilesCommand zcat \
            --sjdbOverhang 100 \
            --chimOutJunctionFormat 1

        STAR-Fusion \
            --genome_lib_dir ${genome_lib} \
            -J Chimeric.out.junction \
            ${read_args} \
            --CPU ${task.cpus} \
            ${params.optional} \
            --output_dir .
        mv star-fusion.fusion_predictions.tsv ${sample_id}_star-fusion.tsv
        mv star-fusion.fusion_predictions.abridged.tsv ${sample_id}_abridged.tsv
        mv star-fusion.fusion_predictions.abridged.coding_effect.tsv ${sample_id}_abridged.coding_effect.tsv
        """
}
