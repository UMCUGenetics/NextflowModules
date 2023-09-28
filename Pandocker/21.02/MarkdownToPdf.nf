process MarkdownToPdf {
    tag {"Pandocker MarkdownToPdf"}
    label 'Pandocker_21_02'
    label 'Pandocker_21_02_MarkdownToPdf'

    container = 'library://dalibo/pandocker:v21.02'
    shell = ['/bin/bash', '-euo', 'pipefail']

    input:        
        path(md_file)
     
    output:        
        path("${md_file.baseName}.pdf")
   
    script:
        """
        pandoc ${md_file} \
            --variable urlcolor=blue \
            --variable linkcolor=blue \
            -s \
            --toc \
            -f markdown \
            -o ${md_file.baseName}.pdf
        """
}
