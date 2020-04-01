process MakeUmiBam {
    tag {"python Makeumibam ${sample_id} "}
    label 'python_2_7_10'
    label 'python_2_7_10_Makeumibam'
    // container = 'container_url'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, flowcell, machine, run_nr, file(fastq: "*")

    output:
    tuple sample_id, flowcell, machine, run_nr, file("${sample_id}.u.grouped.bam")


    script:

    """
    #!/hpc/local/CentOS7/common/lang/python/2.7.10/bin/python

    import pysam
    import sys
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
    group_ids = {}
    # Create groups
    with pysam.FastxFile(fastqs[0]) as r1:
        for r1_read in r1:
            name_parts = r1_read.name.split(':')
            new_name = ":".join(name_parts[0:7])
            umi = "".join(name_parts[-1].split('/')[0].split('-'))
            # if umi not in umis:
            umis[umi] = None
            # umis[umi].append(new_name)

    for group_id, umi in enumerate(umis.keys()):
        group_ids[umi] = group_id

    r1 = pysam.FastxFile(fastqs[0])
    r2 = None
    if len(fastqs) > 1: r2 = pysam.FastxFile(fastqs[1])
    out = pysam.AlignmentFile(out_bam, 'wb', header=header)

    for r1_read in r1:

        name_parts = r1_read.name.split(':')
        new_name = ":".join(name_parts[0:7])
        umi = "".join(name_parts[-1].split('/')[0].split('-'))
        tags = (
            ("MI", str(group_ids[umi])),
            ("RX", str(umi))
        )

        a1 = pysam.AlignedSegment()
        a1.query_name = new_name
        a1.query_sequence = r1_read.sequence
        a1.flag = 77
        a1.query_qualities = pysam.qualitystring_to_array(r1_read.quality)
        a1.tags = tags
        out.write(a1)

        if r2:
            r2_read = r2.next()
            a2 = pysam.AlignedSegment()
            a2.query_name = new_name
            a2.query_sequence = r2_read.sequence
            a2.flag = 141
            a2.query_qualities = pysam.qualitystring_to_array(r2_read.quality)
            a2.tags = tags
            out.write(a2)

    r1.close()
    if r2: r2.close()
    out.close()

    """

}
