process Manta {
    tag {"Manta ConfigAndRun ${sample_id}"}
    label 'Manta_1_6_0'
    label 'Manta_1_6_0_ConfigAndRun'
    //container = 'container_url'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple (sample_id, path(bam_file), path(bai_file))

    output:
        tuple (sample_id, path("*.candidateSmallIndels.*"),path("*.candidateSV.*"),path("*.diploidSV.*"), emit: manta_vcfs )

    script:
        """
        ${params.manta_path}/configManta.py --referenceFasta ${params.genome_fasta} --runDir . --bam $bam_file
        ${params.manta_path}/runWorkflow.py -m local -j ${task.cpus}

        mv Manta/results/variants/candidateSmallIndels.vcf.gz Manta_${sample_id}.candidateSmallIndels.vcf.gz
        mv Manta/results/variants/candidateSmallIndels.vcf.gz.tbi Manta_${sample_id}.candidateSmallIndels.vcf.gz.tbi
        mv Manta/results/variants/candidateSV.vcf.gz Manta_${sample_id}.candidateSV.vcf.gz
        mv Manta/results/variants/candidateSV.vcf.gz.tbi Manta_${sample_id}.candidateSV.vcf.gz.tbi
        mv Manta/results/variants/diploidSV.vcf.gz Manta_${sample_id}.diploidSV.vcf.gz
        mv Manta/results/variants/diploidSVSV.vcf.gz.tbi Manta_${sample_id}.diploidSV.vcf.gz.tbi
        """
}
