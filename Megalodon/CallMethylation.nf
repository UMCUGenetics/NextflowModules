process CallMethylation {
    tag {"MegalodonCallMethylation  ${sample_id}"}
    label 'MegalodonCallMethylation'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        //val(fast5_path)
        path(fast5_files)
        tuple(sample_id, path(reads))

    output:
        path("out/*")

    script:
        //$params.megalodon_path $fast5_path --output-directory ./out/ --reference $params.genome --guppy-server-path $params.guppy_server_path --guppy-params \"$params.guppy_5mC_params\" --guppy-config $params.guppy_5mC_config --devices cuda:0 --processes ${task.cpus} --outputs mods mappings mod_basecalls mod_mappings per_read_mods --mod-map-emulate-bisulfite --mod-map-base-conv C T --mod-map-base-conv m C --mod-motif m CG 0 --write-mods-text --read-ids-filename ${reads} --overwrite
        """
        $params.megalodon_path ./ --output-directory ./out/ --reference $params.genome --guppy-server-path $params.guppy_server_path --guppy-params \"$params.guppy_5mC_params\" --guppy-config $params.guppy_5mC_config --devices cuda:0 --processes ${task.cpus} --outputs mods mappings mod_basecalls mod_mappings per_read_mods --mod-map-emulate-bisulfite --mod-map-base-conv C T --mod-map-base-conv m C --mod-motif m CG 0 --write-mods-text --read-ids-filename ${reads} --overwrite
        cd ./out/
        rename '' ${reads.simpleName}_ *
        """
}
