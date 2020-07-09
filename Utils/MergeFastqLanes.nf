process MergeFastqLanes {
    tag {"MergeFastqLanes ${sample_id} - ${rg_id}"}
    label 'MergeFastqLanes'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, rg_id, path(r1_fastqs), path(r2_fastqs))

    output:
        tuple(sample_id, barcode, path("${sample_id}_${barcode}_merged_*.fastq.gz"), emit: fastqs_merged)


    script:
        barcode = rg_id.split('_')[1]
        if (params.singleEnd) {
            """
            cat \$( ls ${sample_id}_*_S*_L00*_R1_001.fastq.gz | sort | paste \$(printf "%0.s- " \$(seq 1 \$( ls ${sample_id}_*_S*_L00*_R1_001.fastq.gz | wc -l)))) > ${sample_id}_${barcode}_merged_R1.fastq.gz
            """
        } else {
            """
            cat \$( ls ${sample_id}_*_S*_L00*_R1_001.fastq.gz | sort | paste \$(printf "%0.s- " \$(seq 1 \$( ls ${sample_id}_*_S*_L00*_R1_001.fastq.gz | wc -l)))) > ${sample_id}_${barcode}_merged_R1.fastq.gz
            cat \$( ls ${sample_id}_*_S*_L00*_R2_001.fastq.gz | sort | paste \$(printf "%0.s- " \$(seq 1 \$( ls ${sample_id}_*_S*_L00*_R2_001.fastq.gz | wc -l)))) > ${sample_id}_${barcode}_merged_R2.fastq.gz
            """
        }
}

