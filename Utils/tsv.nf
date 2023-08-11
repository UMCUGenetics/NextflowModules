def extractAllTsvFromDir(dir) {
    // Original code from: https://github.com/SciLifeLab/Sarek - MIT License - Copyright (c) 2016 SciLifeLab
    dir = dir.tokenize().collect{"$it/*.tsv"}
    Channel
    .fromPath(dir, type:'file')
    .ifEmpty { error "No tsv files found in ${dir}." }
    .map { tsv_path ->
        tsv_files = [tsv_path]
        sample_id = tsv_path.getSimpleName().split('_')[0]
        chunk = tsv_path.getSimpleName().split('_')[4]

        [sample_id, chunk, tsv_files]
    }
}
