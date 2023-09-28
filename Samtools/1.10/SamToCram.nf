process SamToCram {
    tag {"Samtools SamToCram ${sample_id}"}
    label 'Samtools_1_10'
    label 'Samtools_1_10_SamToCram'
    container = 'quay.io/biocontainers/samtools:1.10--h9402c20_2'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(bam_file), path(bai_file))
        path(genome_fasta)

    output:
        tuple(val(sample_id), path("${bam_file.baseName}.cram"), emit: cram_file)

    script:
        """
        samtools view --threads ${task.cpus} -O cram,embed_ref -T ${genome_fasta} -C -o ${bam_file.baseName}.cram ${bam_file}
        """
}
