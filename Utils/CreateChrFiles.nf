process CreateChrFiles {
    tag {"CreateChrFiles ${genome_fasta.baseName}"}
    label 'CreateChrFiles'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:
        path(genome_fasta)

    output:
        path("./chr_files/", emit: chr_files)

    script:
        """
        chr_files="./chr_files/"
        if [[ ! -d \${chr_files} ]]; then
            
            #################
            ### Split per chr
            #################
            mkdir -p \${chr_files}
		
            # split based on >chr entry
            csplit -s -z ${genome_fasta} '/>/' '{*}'
            # move resulting files using >chr entry for filename
            for i in xx* ; do
                n=\$(sed 's/>// ; s/ .*// ; 1q' "\$i")
                mv "\$i" \${chr_files}/"\${n}.fa"
            done
        fi
        """
}
