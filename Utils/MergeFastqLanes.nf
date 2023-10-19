process MergeFastqLanes {
    tag {"MergeFastqLanes ${sample_id} - ${rg_id}"}
    label 'MergeFastqLanes'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(val(sample_id), val(rg_id), path(fastqs))

    output:
        tuple(val(sample_id), val(rg_id), path("${sample_id}_${barcode}_merged_*.fastq.gz"), emit: fastqs_merged)


    script:
        barcode = rg_id.split('_')[1]
        def R1_pattern="${sample_id}_*_S*_L00*_R1_001*.fastq.gz"
        def R2_pattern="${sample_id}_*_S*_L00*_R2_001*.fastq.gz"
        if (params.single_end) {
            """
            cat \$( ls ${R1_pattern} | sort | paste \$(printf "%0.s- " \$(seq 1 \$( ls ${R1_pattern} | wc -l)))) > ${sample_id}_${barcode}_merged_R1.fastq.gz
            """
        } else {
            """
            cat \$( ls ${R1_pattern} | sort | paste \$(printf "%0.s- " \$(seq 1 \$( ls ${R1_pattern} | wc -l)))) > ${sample_id}_${barcode}_merged_R1.fastq.gz
            cat \$( ls ${R2_pattern} | sort | paste \$(printf "%0.s- " \$(seq 1 \$( ls ${R2_pattern} | wc -l)))) > ${sample_id}_${barcode}_merged_R2.fastq.gz
            """
        }
}

