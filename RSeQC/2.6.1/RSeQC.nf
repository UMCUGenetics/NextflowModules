
process RSeQC {
    tag {"RSeQC ${sample_id}"}
    label 'RSeQC_2.6.1'
    container = '/hpc/cog_bioinf/ubec/tools/rnaseq_containers/rseqc_2.6.1-squashfs-pack.gz.squashfs'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
    tuple sample_id, file(sam_file), file(sam_index), file(bed_genome)

    output:
    tuple sample_id, file("*.{txt,pdf,r,xls})

    script:
    """
    infer_experiment.py -i $sam_file -r $bed12 > ${sample_id}.infer_experiment.txt
    junction_annotation.py -i $sam_file -o ${sample_id}.rseqc -r $bed12
    """
}
