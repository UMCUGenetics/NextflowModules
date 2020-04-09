process CreateIntervalList {
    tag {"CreateIntervalList ${genome_dict.baseName}"}
    label 'CreateIntervalList'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    file(genome_index) 
    file(genome_dict)

    output:
    file("${genome_dict.baseName}.interval_list")


    script:
    """
    awk '{ print \$1"\\t1\\t"\$2"\\t+\\t."}' ${genome_index} | cat ${genome_dict} - > ${genome_dict.baseName}.interval_list
    """

}
