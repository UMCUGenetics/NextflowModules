process CreateBed {
    tag {"CreateBed ${genome_index.baseName}"}
    label 'CreateBed'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        path(genome_index)

    output:
        path("${genome_index.baseName}.bed", emit: genome_bed)

    script:
        """
        awk -v FS='\t' -v OFS='\t' '{ print \$1, "0", \$2 }' ${genome_index} > ${genome_index.baseName}.bed
        """
}
