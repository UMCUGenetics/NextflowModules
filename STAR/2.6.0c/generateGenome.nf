process genomeGenerate {
    tag {"STAR genomeGenerate ${ref_name} "}
    label 'STAR_2_6_0c'
    label 'STAR_2_6_0c_genomeGenerate'
    container = 'quay.io/biocontainers/star:2.6.0c--2'
    //container = '/hpc/local/CentOS7/cog_bioinf/nextflow_containers/STAR/star-2.4.2a-squashfs-pack.gz.squashfs'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple ref_name, file(genome_gtf), file(genome_fasta)
   
   
    output:
    file("${ref_name}/")
     
   
    script:
    """
    mkdir ${ref_name}
    STAR --runMode genomeGenerate \
    --runThreadN ${task.cpus} \
    --sjdbGTFfile ${genome_gtf} \
    --genomeDir ${ref_name} \
    --genomeFastaFiles ${genome_fasta} 
    """
}
