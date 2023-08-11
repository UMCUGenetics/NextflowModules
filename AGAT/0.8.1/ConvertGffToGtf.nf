process ConvertGffToGtf {
    tag {"AGAT ConvertGffToGtf ${gff}"}
    label 'AGAT_0_8_1'
    label 'AGAT_0_8_1_ConvertGffToGtf'
    container = 'quay.io/biocontainers/agat:0.8.1--pl5262hdfd78af_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        path(gff)

    output:
        path("${gff.simpleName}.gtf", emit: gtf)

    script:
        """
        agat_convert_sp_gff2gtf.pl -gff ${gff} -o ${gff.simpleName}.gtf
        """
}
