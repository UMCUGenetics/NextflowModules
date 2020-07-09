def extractBamFromDir(dir){
  Channel
  .fromPath("${dir}/**.bam", type:'file')
  .ifEmpty { error "No .bam files found in ${dir}!" }
  .map { bam ->
    def sample_id = bam.getSimpleName().split('_')[0]
    def bai_path = file(bam.toString().replace('.bam','.bai'))
    def bai_path2 = file(bam.toString().replace('.bam','.bam.bai'))
    if ( bai_path.exists()){
      bai = bai_path
    }
    else if (bai_path2.exists()) {
      bai = bai_path2
    }else{
      error "No .bai file found for ${bam}!"
    }
    [sample_id, bam, bai]
  }
}
