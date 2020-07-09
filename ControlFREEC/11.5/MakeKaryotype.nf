process MakeKaryotype {
    tag {"Control Freec MakeKaryotype ${sample_id}"}
    label 'ControlFreec_11_5'
    label 'ControlFreec_11_5_MakeKaryotype'
    container = 'library://sawibo/default/bioinf-tools:freec11.5'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(ratio_file), path(cnv_file))

    output:
        tuple(sample_id, path("*_karyotype.pdf"), emit: karyotype_pdf)

    script:
        """
        cat /bin/makeKaryotype.R | R --slave --args ${params.ploidy} ${params.maxlevel} ${params.telocentromeric} ${ratio_file}
        """
}
