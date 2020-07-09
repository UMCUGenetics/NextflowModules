
def extractVCFFromDir(dir){
  Channel
  .fromPath("${dir}/**.vcf", type:'file')
  .ifEmpty { error "No .vcf files found in ${dir}!" }
  .map{ vcf ->
    def id = vcf.getSimpleName()
    def idx_path = file(vcf.toString().replace('.vcf','.vcf.idx'))
    if (! idx_path.exists()){
      error "No .idx file found for ${vcf}!"
    }
    [id, vcf, idx_path]
  }
}
