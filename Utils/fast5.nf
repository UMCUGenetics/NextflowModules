def extractFast5FromDir(dir) {
    // Original code from: https://github.com/SciLifeLab/Sarek - MIT License - Copyright (c) 2016 SciLifeLab
    dir = dir.tokenize().collect{"$it/*.fast5"}
    Channel
    .fromPath(dir, type:'file')
    .ifEmpty { error "No fast5 files found in ${dir}." }
    .map { fast5_path ->
        def sample_id = fast5_path.getSimpleName().split('_')[0]
        def chunk = fast5_path.getSimpleName().split('_')[3]
        [sample_id, chunk, fast5_path]
    }
}

def extractAllFast5FromDir(dir) {
    // Original code from: https://github.com/SciLifeLab/Sarek - MIT License - Copyright (c) 2016 SciLifeLab
    dir = dir.tokenize().collect{"$it/*.fast5"}
    Channel
    .fromPath(dir, type:'file')
    .ifEmpty { error "No fast5 files found in ${dir}." }
    .map { fast5_path ->
        fast5_files = [fast5_path]
        sample_id = fast5_path.getSimpleName().split('_')[0]
        def sample_id = fast5_path.getSimpleName().split('_')[0]
        def chunk = fast5_path.getSimpleName().split('_')[4]
        
        [sample_id, chunk, fast5_files]
    }
}
