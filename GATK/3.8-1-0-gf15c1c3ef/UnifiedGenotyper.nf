params.process_outdir = 'UnifiedGenotyper'
params.gatk
params.genome
params.intervals = ''
params.dbsnp = ''
params.output_mode = 'EMIT_VARIANTS_ONLY'

process UnifiedGenotyper {
    tag "${sample}_gatk_UG"
    publishDir "$params.outdir/$params.process_outdir", mode: 'copy'
    cpus 2
    penv 'threaded'
    memory '5 GB'
    time '1h'

    input:
    set val(sample), file(input_bam), file(input_bai)

    output:
    set val(sample), file("${sample}.vcf")

    script:
    def intervals = params.intervals ? "--intervals $params.intervals" : ''
    def dbsnp = params.dbsnp ? "--dbsnp $params.dbsnp" : ''
    """
    module load Java/1.8.0_60
    java -jar $params.gatk -T UnifiedGenotyper --reference_sequence $params.genome --input_file $input_bam --out ${sample}.vcf --output_mode $params.output_mode $intervals $dbsnp
    """
}
