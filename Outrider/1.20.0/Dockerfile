################## BASE IMAGE ######################
FROM --platform=linux/amd64 quay.io/biocontainers/bioconductor-outrider:1.18.1--r43hf17093f_0

################## METADATA ######################
LABEL base_image="outrider:1.18.1--r43hf17093f_0"
LABEL version="1.18.1--r43hf17093f_0"
LABEL software="dependencies_custom_outrider"
LABEL about.summary=""
LABEL about.home="https://github.com/gagneurlab/OUTRIDER"
LABEL about.documentation="https://github.com/gagneurlab/OUTRIDER"
# LABEL extra.binaries="R"

################## INSTALLATIONS ######################

RUN R -e "install.packages('argparse', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('tools', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('tibble', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('readr', dependencies=TRUE, repos='http://cran.rstudio.com/')"
RUN R -e "install.packages('dplyr', dependencies=TRUE, repos='http://cran.rstudio.com/')"
