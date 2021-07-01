process BafRegress {
    // Contamination estimate
    // B allele frequency regression models
    tag {"BafRegress ${sample_id}"}
    // tool has no release versions, using 1.0.0 as default.
    label 'BafRegress_1_0_0'
    label 'BafRegress_1_0_0_BafRegress'
    shell = ['/bin/bash', '-euo', 'pipefail']
    container = 'evandegeer/bafregress:1.0.0'

    input:
        tuple (val(sample_id), path(input_vcf), path(input_vcf_index))

    output:
        tuple (val(sample_id), path("${sample_id}_bafregress_report.txt"), emit: baffregress)

    script:
        """
        bcftools view \
        -f 'PASS,.' \
        -r 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22 \
        ${input_vcf} | \
        python /tools/VCFtoFinalReportForBafRegress/parseVcfToBAFRegress.py > tmp_report.txt

        python /tools/bafRegress.py estimate \
        --freqfile ${params.maf_file} \
        tmp_report.txt \
        > ${sample_id}_bafregress_report.txt
        """
}