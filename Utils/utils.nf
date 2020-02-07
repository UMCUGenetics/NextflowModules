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
    sample_id = r1_path.getSimpleName().split('_')[0]
    chunk_id = r1_path.getSimpleName().split('_')[-1]
    files = [r1_path]
    r2_path = file(r1_path.toString().replace('_R1_', '_R2_'))
    if ( r2_path.exists() ) files.add(r2_path)
    (flowcell, lane) = flowcellLaneFromFastq(r1_path)
    rg_id = "${sample_id}_${flowcell}_${lane}_${chunk_id}"
    [sample_id, rg_id, files ]
  }
}

def extractBamFromDir(dir){
  Channel
  .fromPath("${dir}/**.bam", type:'file')
  .ifEmpty { error "No .bam files found in ${dir}!" }
  .map { bam_path ->
    def sample_id = bam_path.getSimpleName().split('_')[0]
    def bai_path = file(bam_path.toString().replace('bam','bai'))
    def bai_path2 = file(bam_path.toString().replace('bam','bam.bai'))
    if (! bai_path.exists() && ! bai_path2.exists()) error "No .bai file found for ${bam_path}!"
    [sample_id, bam_path, bai_path]
  }
}
