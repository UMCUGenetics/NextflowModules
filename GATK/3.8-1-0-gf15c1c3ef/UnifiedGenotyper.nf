params.process_outdir = 'UnifiedGenotyper'
params.gatk
params.genome
params.intervals = ''
params.dbsnp = ''
params.output_mode = 'EMIT_VARIANTS_ONLY'

process UnifiedGenotyper {
    tag "GATKUnifiedGenotyper_${sample_id}"
    
    input:
    set val(sample_id), file(input_bam), file(input_bai)

    output:
    set val(sample_id), file("${sample_id}.vcf")

    script:
    def intervals = params.intervals ? "--intervals $params.intervals" : ''
    def dbsnp = params.dbsnp ? "--dbsnp $params.dbsnp" : ''
    """
    module load Java/1.8.0_60
    java -jar $params.gatk -T UnifiedGenotyper --reference_sequence $params.genome --input_file $input_bam --out ${sample_id}.vcf --output_mode $params.output_mode $intervals $dbsnp
    """
}
