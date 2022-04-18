def extractAllFast5FromDirONT(dir) {
    dir = dir.tokenize().collect{"$it/**.fast5"}
    Channel
    .fromPath(dir, type:'file')
    .ifEmpty { error "No fast5 files found in ${dir}." }
}
