def extractVCFFromDir(dir){
    Channel
    .fromPath(["${dir}/**.vcf", "${dir}/**.vcf.gz"], type:'file')
    .ifEmpty { error "No .vcf or .vcf.gz files found in ${dir}!" }
    .map{ vcf ->
        def id = vcf.getSimpleName()
        def idx_path = file(vcf.toString().replace('.vcf','.vcf.idx'))
        if (! idx_path.exists()){
            idx_path = file(vcf.toString().replace('.vcf.gz','.vcf.gz.tbi'))
            if (! idx_path.exists()){
                error "No index file (vcf.idx or vcf.gz.tbi) found for ${vcf}!"
            }
        }
        [id, vcf, idx_path]
    }
}
