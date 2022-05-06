def extractIdatPairFromDir(dir) {
    dir = dir.tokenize().collect{"$it/**_Grn.idat"}
    Channel
    .fromPath(dir, type:'file')
    .ifEmpty { error "No green idat files found in ${dir}." }
    .map { grn_path ->
        def array_id = grn_path.getSimpleName().split('_')[0]
        def position = grn_path.getSimpleName().split('_')[1]
        def red_path = file(grn_path.toString().replace('_Grn', '_Red'), checkIfExists: true)
        def sample_id = "${array_id}_${position}"
        [sample_id, array_id, grn_path, red_path]
    }
}
