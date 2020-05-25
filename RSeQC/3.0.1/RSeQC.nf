
process RSeQC {
    tag {"RSeQC ${sample_id}"}
    label 'RSeQC_3_0_1'
    container = "quay.io/biocontainers/rseqc:3.0.1--py37h516909a_1"
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(bam_file), path(bai_file))
        path(genome_bed12)

    output:
        tuple(sample_id, path("*.{txt,pdf,r,xls}"), emit: qc_files)

    script:
        //Adapted code from: https://github.com/nf-core/rnaseq - MIT License - Copyright (c) Phil Ewels, Rickard Hammarén
        """
        inner_distance.py -i ${bam_file} -o ${bam_file.baseName}.rseqc -r ${genome_bed12}
        read_distribution.py -i ${bam_file} -r ${genome_bed12} > ${bam_file.baseName}.read_distribution.txt
        infer_experiment.py -i ${bam_file} -r ${genome_bed12} > ${bam_file.baseName}.infer_experiment.txt
        junction_annotation.py -i ${bam_file} -o ${bam_file.baseName}.rseqc -r ${genome_bed12}
        bam_stat.py -i ${bam_file} > ${bam_file.baseName}.bam_stat.txt
        junction_saturation.py -i ${bam_file} -o ${bam_file.baseName}.rseqc -r ${genome_bed12} 2> ${bam_file.baseName}.junction_annotation_log.txt
        read_duplication.py -i ${bam_file} -o ${bam_file.baseName}.read_duplication
        """
}
//Separated from RSeQC due to memory requirements
process RSeQC_TIN {
    tag {"RSeQC ${sample_id}"}
    label 'RSeQC_3_0_1'
    label 'RSeQC_3_0_1_TIN'
    container = "quay.io/biocontainers/rseqc:3.0.1--py37h516909a_1"
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(bam_file), path(bai_file))
        path(genome_bed12)

    output:
        tuple(sample_id, path("*.{txt,xls}"), emit: tin_stats)

    script:
        //Adapted code from: https://github.com/nf-core/rnaseq - MIT License - Copyright (c) Phil Ewels, Rickard Hammarén
        """
        tin.py -i ${bam_file} -r ${genome_bed12}
        """
}




