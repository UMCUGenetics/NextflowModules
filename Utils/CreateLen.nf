process CreateLen {
    tag {"CreateLen ${genome_index.baseName}"}
    label 'CreateLen'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        path(genome_index)

    output:
        path("${genome_index.baseName}.len", emit: genome_len)

    script:
        """
	awk '{gsub("chr", "", \$1); print \$1"\\tchr"\$1"\\t"\$2}' ${genome_index} > ${genome_index.baseName}.len
        """

}
