process Manta {
    tag {"Manta ConfigAndRun ${sample_id}"}
    label 'Manta_1_6_0'
    label 'Manta_1_6_0_ConfigAndRun'
    container = 'quay.io/biocontainers/manta:1.6.0--py27_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple (sample_id, path(bam_file), path(bai_file))

    output:
        tuple (sample_id, path("*.candidateSmallIndels.*"),path("*.candidateSV.*"),path("*.diploidSV.*"), emit: sv )

    script:
        """
        configManta.py --referenceFasta ${params.genome_fasta} --runDir . --bam $bam_file
        ./runWorkflow.py -m local -j ${task.cpus}

        mv results/variants/candidateSmallIndels.vcf.gz Manta_${sample_id}.candidateSmallIndels.vcf.gz
        mv results/variants/candidateSmallIndels.vcf.gz.tbi Manta_${sample_id}.candidateSmallIndels.vcf.gz.tbi
        mv results/variants/candidateSV.vcf.gz Manta_${sample_id}.candidateSV.vcf.gz
        mv results/variants/candidateSV.vcf.gz.tbi Manta_${sample_id}.candidateSV.vcf.gz.tbi
        mv results/variants/diploidSV.vcf.gz Manta_${sample_id}.diploidSV.vcf.gz
        mv results/variants/diploidSV.vcf.gz.tbi Manta_${sample_id}.diploidSV.vcf.gz.tbi
        """
}
