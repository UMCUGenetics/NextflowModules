################## BASE IMAGE ######################

FROM --platform=linux/amd64 ubuntu:latest

################## METADATA ######################
LABEL base_image="biocontainers:v1.0.0_cv4"
LABEL version="4"
LABEL software="BafRegress"
LABEL about.summary="Detects and estimates sample contamination using B allele frequency data from Illumina genotyping arrays using a regression model."
LABEL about.home="https://genome.sph.umich.edu/wiki/BAFRegress"
LABEL about.documentation="https://genome.sph.umich.edu/wiki/BAFRegress"
LABEL about.tags="Genomics"
LABEL extra.binaries="bafregress,bcftools"

################## INSTALLATIONS ######################

ARG bcftools_version=1.11

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    build-essential \
    r-base \
    r-cran-randomforest \
    python \
    libbz2-dev zlib1g-dev liblzma-dev \
    wget \
    git

WORKDIR /tools/

# Install BafRegress
RUN wget 'https://genome.sph.umich.edu/w/images/d/d5/BafRegress.tar.gz' && \
    tar xf BafRegress.tar.gz && \
    rm BafRegress.tar.gz

# Install bcftools
RUN wget -q https://github.com/samtools/bcftools/releases/download/${bcftools_version}/bcftools-${bcftools_version}.tar.bz2 && \
    tar xf bcftools-${bcftools_version}.tar.bz2 && \
    rm bcftools-${bcftools_version}.tar.bz2 && \
    cd bcftools-${bcftools_version} && \
    ./configure && \
    make && \
    make install && \
    cd ../ && \
    rm -r bcftools-${bcftools_version}  # Don't need the source directory now that we've installed the binary.

# install VCFtoFinalReportForBafRegress using git.
RUN git clone https://github.com/jpdna/VCFtoFinalReportForBafRegress.git





