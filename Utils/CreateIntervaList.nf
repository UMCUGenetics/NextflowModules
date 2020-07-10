process CreateIntervalList {
    tag {"CreateIntervalList ${genome_dict.baseName}"}
    label 'CreateIntervalList'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        path(genome_index) 
        path(genome_dict)

    output:
        path ("${genome_dict.baseName}.interval_list", emit: genome_interval_list)


    script:
        """
        awk '{ print \$1"\\t1\\t"\$2"\\t+\\t."}' ${genome_index} | cat ${genome_dict} - > ${genome_dict.baseName}.interval_list
        """

}
