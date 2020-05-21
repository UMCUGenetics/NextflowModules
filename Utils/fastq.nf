def flowcellLaneFromFastq(path) {
    // Original code from: https://github.com/SciLifeLab/Sarek - MIT License - Copyright (c) 2016 SciLifeLab

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
    String machine
    int run_nr
    String fcid
    int lane

    if (fields.size() == 7) {
        // CASAVA 1.8+ format
        machine = fields[0]
        run_nr = fields[1].toInteger()
        fcid = fields[2]
        lane = fields[3].toInteger()
    }
    else if (fields.size() == 5) {
        fcid = fields[0]
        lane = fields[1].toInteger()
    }
    [fcid, lane, machine, run_nr]
}

def extractFastqPairFromDir(dir) {
    // Original code from: https://github.com/SciLifeLab/Sarek - MIT License - Copyright (c) 2016 SciLifeLab
    dir = dir.tokenize().collect{"$it/**_R1_*.fastq.gz"}
    Channel
    .fromPath(dir, type:'file')
    .ifEmpty { error "No R1 fastq.gz files found in ${dir}." }
    .filter { !(it =~ /.*Undetermined.*/) }
    .map { r1_path ->
        def fastq_files = [r1_path]
        def sample_id = r1_path.getSimpleName().split('_')[0]
        def r2_path = file(r1_path.toString().replace('_R1_', '_R2_'))
        if (r2_path.exists()) {
            fastq_files.add(r2_path)
        } else {
            exit 1, "R2 fastq.gz file not found: ${r2_path}."
        }
        def (flowcell, lane) = flowcellLaneFromFastq(r1_path)
        def rg_id = "${sample_id}_${flowcell}_${lane}"
        [sample_id, rg_id, fastq_files]
    }
}

def extractFastqFromDir(dir) {
    // Original code from: https://github.com/SciLifeLab/Sarek - MIT License - Copyright (c) 2016 SciLifeLab
    dir = dir.tokenize().collect{"$it/*.fastq.gz"}
    Channel
    .fromPath(dir, type:'file')
    .ifEmpty { error "No fastq.gz files found in ${dir}." }
    .filter { !(it =~ /.*Undetermined.*/) }
    .map { fastq_path ->
        def sample_id = fastq_path.getSimpleName().split('_')[0]
        def (flowcell, lane) = flowcellLaneFromFastq(fastq_path)
        def rg_id = "${sample_id}_${flowcell}_${lane}"
        if (fastq_path.getSimpleName().contains('_R1_')) rg_id = "${rg_id}_R1"
        if (fastq_path.getSimpleName().contains('_R2_')) rg_id = "${rg_id}_R2"
        [sample_id, rg_id, fastq_path]
    }
}

def extractAllFastqFromDir(dir) {
    // Original code from: https://github.com/SciLifeLab/Sarek - MIT License - Copyright (c) 2016 SciLifeLab
    dir = dir.tokenize().collect{"$it/**_R1_*.fastq.gz"}
    Channel
    .fromPath(dir, type:'file')
    .ifEmpty { error "No R1 fastq.gz files found in ${dir}." }
    .map { r1_path ->
        fastq_files = [r1_path]
        sample_id = r1_path.getSimpleName().split('_')[0]
        r2_path = file(r1_path.toString().replace('_R1_', '_R2_'))
        r3_path = file(r1_path.toString().replace('_R1_', '_R3_'))
        
        if (r2_path.exists()) fastq_files.add(r2_path)
        if (r3_path.exists()) fastq_files.add(r3_path)

        (flowcell, lane, machine, run_nr) = flowcellLaneFromFastq(r1_path)
        rg_id = "${sample_id}_${flowcell}_${lane}"
        [sample_id, rg_id, machine, run_nr ,fastq_files]
    }
}
