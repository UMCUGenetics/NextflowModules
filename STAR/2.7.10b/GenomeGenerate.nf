process GenomeGenerate {
    tag {"STAR GenomeGenerate ${genome_fasta.baseName} "}
    label 'STAR_2_7_10b'
    label 'STAR_2_7_10b_GenomeGenerate'
    container = 'quay.io/biocontainers/star:2.7.10b--h9ee0642_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        path(genome_fasta)
        path(genome_gtf)
    
    output:
        path("star_genome", emit: star_path)     
   
    script:
        //Adapted code from: https://github.com/nf-core/rnaseq - MIT License - Copyright (c) Phil Ewels, Rickard Hammarén
        def avail_mem = task.memory ? "--limitGenomeGenerateRAM ${task.memory.toBytes() - 100000000}" : ''

        """
        mkdir -p star_genome
        STAR \
            --runMode genomeGenerate \
            --runThreadN ${task.cpus} \
            --sjdbGTFfile ${genome_gtf} \
            --genomeDir star_genome/ \
            --genomeFastaFiles ${genome_fasta} \
            $avail_mem
        """
}
