process SamToCram {
    tag {"Samtools SamToCram ${bam_file}"}
    label 'Samtools_1_16_1'
    label 'Samtools_1_16_1_SamToCram'
    container = 'quay.io/biocontainers/samtools:1.16.1--h6899075_1'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(path(bam_file), path(bai_file))
        path(genome_fasta)

    output:
        tuple(path("${bam_file.baseName}.cram"), path("${bam_file.baseName}.cram.crai"), emit: cram_file)

    script:
        output_options = params.cram_embedref ? "cram,embed_ref" : "cram"
        """
        samtools view --threads ${task.cpus} -O ${output_options} -T ${genome_fasta} -C -o ${bam_file.baseName}.cram ${bam_file}
        samtools index -@ ${task.cpus} ${bam_file.baseName}.cram
        """
}
