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
        tuple(sample_id, "${sam_file.baseName}.striquemodel.tsv")

    script:
        """
        export HDF5_PLUGIN_PATH=/hpc/compgen/users/cvermeulen/hdf5_plugin/ont-vbz-hdf-plugin-1.0.1-Linux/usr/local/hdf5/lib/plugin
        python3 /app/scripts/STRique.py count --algn ${sam_file} --t ${task.cpus} ${fofn_file} /app/models/$params.striquemodel $params.strique_config > ${sam_file.baseName}.striquemodel.tsv
        """
}
