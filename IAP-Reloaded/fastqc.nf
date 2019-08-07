process FastQC {
  tag {sampleId + "-" + rgId }

  input:
    set sampleId, rgId, file(r1_fastq), file(r2_fastq) from input_files


  '''
    echo "$sampleId"
  '''
}
