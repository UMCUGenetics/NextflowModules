process CallRepeat {
    tag {"STRique Repeat ${sample_id}"}
    label 'STRique_Repeat_0_4_2'
    container = 'docker://giesselmann/strique:latest'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        tuple(sample_id, path(sam_file))
        path(fofn_file)
        path(fast5_files)
    output:
        tuple(sample_id, "${sam_file.simpleName}.striquemodel.tsv")

    script:
        """
        export HDF5_PLUGIN_PATH=$params.libvbz_hdf_plugin
        python3 /app/scripts/STRique.py count --algn ${sam_file} --t ${task.cpus} ${fofn_file} /app/models/$params.striquemodel $params.strique_config > ${sam_file.simpleName}.striquemodel.tsv
        """
}
