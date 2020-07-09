process CountUMIFamilies {
    tag {"python CountUMIFamilies ${sample_id} "}
    label 'python_2_7_10'
    label 'python_2_7_10_CountUMIFamilies'
    container = 'library://sawibo/default/bioinf-tools:idt-umi-dependencies'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple (sample_id, flowcell, machine, run_nr, path(bam))

    output:
        path("${sample_id}_${flowcell}.family_counts", emit:family_counts)

    script:
        """
        #!/gnu/store/vbvjlhhx6y64fvbxh2604sqw9shn02wq-python2-2.7.16R/bin/python

        import sys
        import pysam
        import re

        bam = "${bam}"
        out = "${sample_id}_${flowcell}.family_counts"
        total_read_nr = 0
        filtered_read_nr = 0

        family_counts = {}
        with pysam.AlignmentFile(bam, "r", check_sq=False) as b:
         for read in b:

          if read.flag == 77:
           if read.get_tag('cD') not in family_counts:
            family_counts[ int(read.get_tag('cD')) ] = 0
           family_counts[ int(read.get_tag('cD')) ]+= 1

           filtered_read_nr += 1
           total_read_nr += int(read.get_tag('cD'))

        with open(out, 'w') as o:
         o.write('Raw fragment count\\tHigh quality fragment count\\n')
         o.write("{0}\\t{1}\\n\\n".format(total_read_nr, filtered_read_nr))
         o.write('UMI Family Size\\tOccurrence\\n')
         for c in sorted(family_counts, key=family_counts.get):
          o.write("{0}\\t{1}\\n".format(c, family_counts[c]))
        """

}
