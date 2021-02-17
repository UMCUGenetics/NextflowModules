process CheckContamination {
    tag {"VerifyBamID CheckContamination ${sample_id}.${int_tag}"}
    label 'VERIFYBAMID_2_0_1_h32f71e1_0'
    label 'VERIFYBAMID_2_0_1_h32f71e1_0_CheckContamination'
    container = 'quay.io/biocontainers/verifybamid2:2.0.1--h32f71e1_0'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple (sample_id, path(bam), path(bai))

    output:
        tuple (sample_id, path("${output_prefix}.selfSM"), emit:contamination)

    script:
        def output_prefix = "${sample_id}.${params.library_strategy}.contamination"

        """
        # creates a ${output_prefix}.selfSM file, a TSV file with 2 rows, 19 columns.
        # First row are the keys (e.g., SEQ_SM, RG, FREEMIX), second row are the associated values
        VerifyBamID \
        --Verbose \
        --NumPC 4 \
        --Output  ${output_prefix} \
        --BamFile ${bam} \
        --Reference ${params.genome_fasta} \
        --UDPath ${params.contamination_sites_ud} \
        --MeanPath ${params.contamination_sites_mu} \
        --BedPath ${params.contamination_sites_bed} \
        1>/dev/null

        """
        /*
        # used to read from the selfSM file and calculate contamination, which gets printed out
        python3 <<CODE
        import csv
        import sys
        with open('${output_prefix}.selfSM') as selfSM:
        reader = csv.DictReader(selfSM, delimiter='\t')
        i = 0
        for row in reader:
            if float(row["FREELK0"])==0 and float(row["FREELK1"])==0:
            # a zero value for the likelihoods implies no data. This usually indicates a problem rather than a real event.
            # if the bam isn't really empty, this is probably due to the use of a incompatible reference build between
            # vcf and bam.
            sys.stderr.write("Found zero likelihoods. Bam is either very-very shallow, or aligned to the wrong reference (relative to the vcf).")
            sys.exit(1)
            print(float(row["FREEMIX"])/${params.contamination_underestimation_factor})
            i = i + 1
            # there should be exactly one row, and if this isn't the case the format of the output is unexpectedly different
            # and the results are not reliable.
            if i != 1:
            sys.stderr.write("Found %d rows in .selfSM file. Was expecting exactly 1. This is an error"%(i))
            sys.exit(2)
        CODE
        */

}
