def flowcellLaneFromFastq(path) {
  // parse first line of a FASTQ file (optionally gzip-compressed)
  // and return the flowcell id and lane number.
  // expected format:
  // xx:yy:FLOWCELLID:LANE:... (seven fields)
  // or
  // FLOWCELLID:LANE:xx:... (five fields)
  InputStream fileStream = new FileInputStream(path.toFile())
  InputStream gzipStream = new java.util.zip.GZIPInputStream(fileStream)
  Reader decoder = new InputStreamReader(gzipStream, 'ASCII')
  BufferedReader buffered = new BufferedReader(decoder)
  def line = buffered.readLine()
  assert line.startsWith('@')
  line = line.substring(1)
  def fields = line.split(' ')[0].split(':')
  String fcid
  int lane
  if (fields.size() == 7) {
    // CASAVA 1.8+ format
    fcid = fields[2]
    lane = fields[3].toInteger()
  }
  else if (fields.size() == 5) {
    fcid = fields[0]
    lane = fields[1].toInteger()
  }
  [fcid, lane]
}


def extractFastqFromDir(dir){
  Channel
  .fromPath("${dir}/**_R1_*.fastq.gz", type:'file')
  .ifEmpty { error "No fastq.gz files found in ${dir}!" }
  .filter { !(it =~ /.*Undetermined.*/) }
  .map { r1_path ->
    def sample_id = r1_path.getSimpleName().split('_')[0]
    def chunk_id = r1_path.getSimpleName().split('_')[-1]
    def files = [r1_path]
    def r2_path = file(r1_path.toString().replace('_R1_', '_R2_'))
    if ( r2_path.exists() ) files.add(r2_path)
    (flowcell, lane) = flowcellLaneFromFastq(r1_path)
    def rg_id = "${sample_id}_${flowcell}_${lane}_${chunk_id}"
    [sample_id, rg_id, files ]
  }
}

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
