def extractIdatPairFromDir(dir) {
    dir = dir.tokenize().collect{"$it/**_Grn.idat"}
    Channel
    .fromPath(dir, type:'file')
    .ifEmpty { error "No green idat files found in ${dir}." }
    .map { grn_path ->
        def array_id = grn_path.getSimpleName().split('_')[0]
        def position = grn_path.getSimpleName().split('_')[1]
        def red_path = file(grn_path.toString().replace('_Grn', '_Red'))
        if (! red_path.exists()) {
            exit 1, "Red idat file not found: ${red_path}."
        }
        def assay_id = "${array_id}_${position}"
        [assay_id, array_id, grn_path, red_path]
    }
}
