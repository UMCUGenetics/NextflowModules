
def extractGVCFFromDir(dir){
  Channel
  .fromPath("${dir}/**.g.vcf.gz", type:'file')
  .ifEmpty { error "No .g.vcf files found in ${dir}!" }
  .map{ gvcf ->
    def sample_id = gvcf.getSimpleName()
    def idx_path = file(gvcf.toString().replace('.g.vcf.gz','.g.vcf.gz.tbi'))
    if (! idx_path.exists()){
      error "No .tbi file found for ${gvcf}!"
    }
    [sample_id, gvcf, idx_path]
  }
}
