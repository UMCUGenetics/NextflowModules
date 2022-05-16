process Index {
    tag {"STRique Index ${fast5_files}"}
    label 'STRique_Index_0_4_2'
    container = 'docker://giesselmann/strique:latest'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        path(fast5_files)

    output:
        path("${fast5_files.simpleName}.fofn")

    script:
        """
        export HDF5_PLUGIN_PATH=$params.libvbz_hdf_plugin
        python3 /app/scripts/STRique.py index ${fast5_files}  > ${fast5_files.simpleName}.fofn
        """
}
