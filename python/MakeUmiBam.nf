process MakeUMIBam {
    tag {"python MakeUMIBam ${sample_id} "}
    label 'python_2_7_10'
    label 'python_2_7_10_MakeUMIBam'
    container = 'library://sawibo/default/bioinf-tools:idt-umi-dependencies'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple (sample_id, flowcell, machine, run_nr, path(fastq))

    output:
        tuple (sample_id, flowcell, machine, run_nr, path("${sample_id}.u.grouped.bam"), emit: umi_bams)


    script:
        """
        #!/gnu/store/vbvjlhhx6y64fvbxh2604sqw9shn02wq-python2-2.7.16R/bin/python

        import sys
        import pysam
        import re

        fastqs = "${fastq}".split()
        flowcell = "${flowcell}"
        id = "${sample_id}_"+flowcell
        sample_name = "${sample_id}"
        out_bam = "${sample_id}.u.grouped.bam"


        header = {
            'HD': {'VN': '1.6', 'SO':'unsorted', 'GO':'query'},
            'RG': [{
                'ID':id,
                'SM':sample_name,
                'LB':sample_name,
                'PL':'ILLUMINA',
                'PU':flowcell
            }]
        }
        umis = {}
        # Create groups
        r1,r2,umi_reads = (None,None,None)
        out = pysam.AlignmentFile(out_bam, 'wb', header=header)

        if len(fastqs) == 2:
            r1 = pysam.FastxFile(fastqs[0])
            umi_reads = pysam.FastxFile(fastqs[1])
        elif len(fastqs) == 3:
            r1 = pysam.FastxFile(fastqs[0])
            umi_reads = pysam.FastxFile(fastqs[1])
            r2 = pysam.FastxFile(fastqs[2])

        group_id = 0
        for r1_read in r1:
            r1_read.sequence[0:9]
            umi_read = umi_reads.next()
            umi_seq = r1_read.sequence[0:9]+umi_read.sequence

            if umi_seq not in umis:
                umis[umi_seq] = group_id
                group_id+=1

            tags = (
                ("MI", str(umis[umi_seq])),
                ("RX", str(umi_seq))
            )

            a1 = pysam.AlignedSegment()
            a1.query_name = r1_read.name
            a1.query_sequence = r1_read.sequence
            a1.flag = 77
            a1.query_qualities = pysam.qualitystring_to_array(r1_read.quality)
            a1.tags = tags
            out.write(a1)

            if r2:
                r2_read = r2.next()
                a2 = pysam.AlignedSegment()
                a2.query_name = r2_read.name
                a2.query_sequence = r2_read.sequence
                a2.flag = 141
                a2.query_qualities = pysam.qualitystring_to_array(r2_read.quality)
                a2.tags = tags
                out.write(a2)

        r1.close()
        if r2: r2.close()
        umi_reads.close()
        out.close()

        """

}
