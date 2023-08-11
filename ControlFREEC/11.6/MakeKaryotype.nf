process MakeKaryotype {
    tag {"Control Freec MakeKaryotype ${sample_id}"}
    label 'ControlFreec_11_6'
    label 'ControlFreec_11_6_MakeKaryotype'
    container = 'quay.io/biocontainers/control-freec:11.6--h87f3376_2'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), path(ratio_file), path(cnv_file))

    output:
        tuple(val(sample_id), path("*_karyotype.pdf"), emit: karyotype_pdf)

    script:
        """
        cat makeKaryotype.R | R --slave --args ${params.ploidy} ${params.maxlevel} ${params.telocentromeric} ${ratio_file}
        """
}
