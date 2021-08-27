process CollectArraysVariantCallingMetrics {
    tag {"CollectArraysVariantCallingMetrics ${identifier}"}
    label 'PICARD_2_25_5_hdfd78af_0'
    label 'PICARD_2_25_5_hdfd78af_0_CollectArraysVariantCallingMetrics'
    container = 'quay.io/biocontainers/picard:2.25.5--hdfd78af_0'
    shell = ['/bin/bash', '-euo', 'pipefail']
    
    input:
        tuple (
            val(identifier),
            path(input_vcf),
            path(input_vcf_index)
        )
    output:
        tuple(
            path("${output_prefix}.arrays_variant_calling_summary_metrics"),
            path("${output_prefix}.arrays_variant_calling_detail_metrics"),
            path("${output_prefix}.arrays_control_code_summary_metrics"),
            path("pass.txt")
        )

    script:
        def output_prefix = params.output_prefix ?  params.output_prefix : identifier + "_VC_metrics"

        """
        picard -Xmx${task.memory.toGiga()-4}G \
        CollectArraysVariantCallingMetrics \
        --TMP_DIR \$TMPDIR \
        --INPUT ${input_vcf} \
        --OUTPUT ${output_prefix} \
        --DBSNP ${params.dbsnp} \
        --CALL_RATE_PF_THRESHOLD ${params.call_rate_threshold}

        # Need to determine the disposition from the metrics.
        # Remove all the comments and blank lines from the file
        # Find the column number of AUTOCALL_PF and retrieve the value in the second line of the AUTOCALL_PF column
        # AUTOCALL_PF set to empty if file has more than 2 lines (should only have column headers and one data line)
        AUTOCALL_PF=$(sed '/#/d' ${output_prefix}.arrays_variant_calling_detail_metrics | sed '/^\s*$/d' |
        awk -v col=AUTOCALL_PF -F '\t' \
        'NR==1 {
            for(i=1;i<=NF;i++){
                if(\$i==col){
                    c=i;break
                }
            }
        } NR==2 {
            print $c
        } NR>2 {
            exit 1
        }')

        if [[ "\$AUTOCALL_PF" == "Y" ]]
        then
            echo true > pass.txt
        elif [[ "\$AUTOCALL_PF" == "N" ]]
        then
            echo false > pass.txt
        else
            echo "AUTOCALL_PF should only be Y or N and there should only be one line of data"
            exit 1;
        fi
        """
}