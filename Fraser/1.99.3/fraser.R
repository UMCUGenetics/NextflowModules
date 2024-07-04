
# load FRASER library
suppressPackageStartupMessages(library(FRASER))
suppressPackageStartupMessages(library(biomaRt))
suppressPackageStartupMessages(library(utils))

args <- commandArgs()


get_st_rows <- function(input){
  if(dir.exists(input)){
    sampleID <- list.files(path=input,pattern="*.bam",full.names=FALSE)
    bamFile <- list.files(path=input,pattern="*.bam",full.names=TRUE)
    return(data.table(sampleID,bamFile))
  }
  else if(file.exists(input)){
    sampleID <- basename(file.path(input))
    bamFile <- file.path(input)
    return(data.table(sampleID,bamFile))
  }
}


create_sample_table <- function(sample,ref,paired_end){
  sampleTable <- rbind(get_st_rows(sample),get_st_rows(ref))
  sampleTable <- sampleTable[!grepl(".bai",sampleID), ]
  sampleTable$group <- c(1:nrow(sampleTable))
  sampleTable$pairedEnd <- TRUE

  message(date(), ": sampleTable")
  print(sampleTable)

  return(sampleTable)
}


run_fraser <- function(sampleTable){
  # create FRASER object
  settings <- FraserDataSet(colData=sampleTable, workingDir="./FRASER_output")
  message(date(), ": settings...")
  print(settings)

  register(MulticoreParam(workers=min(8, multicoreWorkers())))

  # count reads
  fds <- countRNAData(settings)

  fds <- calculatePSIValues(fds)
    #FRASER vignette/gagneurlab settings:
  #Currently, we suggest keeping only junctions which support the following:
  #minExpressionInOneSample - 20 - At least one sample has 20 (or more) reads
  #quantileMinExpression - 10 - The minimum total read count (N) an intron needs to have at the specified quantile across samples to pass the filter. See quantileForFiltering. 
  #quantile - 0.95 -  Defines at which percentile the quantileMinExpression filter is applied. 
  #A value of 0.95 means that at least 5% of the samples need to have a total read count N >= quantileMinExpression to pass the filter.
  #minDeltaPsi - 0.05 -  The minimal variation (in delta psi) required for an intron to pass the filter. gagneurlab suggests 0.05

  fds <- filterExpressionAndVariability(fds, minExpressionInOneSample = 20, quantileMinExpression=10, quantile = 0.95, minDeltaPsi=0.05, filter=FALSE)
  fds <- saveFraserDataSet(fds, name="fds-filter")
#  plotheat = "plots_fraser.pdf"
#  pdf(plotheat,onefile = TRUE)
#  plotFilterExpression(fds, bins=100)

  message(date(), ": dimension before filtering...")
  print(dim(fds))
  fds <- fds[mcols(fds, type="j")[,"passed"]]
  message(date(), ": dimension after filtering...")
  print(dim(fds))

  #Finds the optimal encoding dimension by injecting artificial splicing outlier ratios while maximizing the precision-recall curve.
  # Get range for latent space dimension, max tested dimensions = 6
  mp <- 6
  a <- 2
  b <- min(ncol(fds), nrow(fds)) / mp   # N/mp

  maxSteps <- 12
  if(mp < 6){
    maxSteps <- 15
  }

  Nsteps <- min(maxSteps, b)
  pars_q <- unique(round(exp(seq(log(a),log(b),length.out = Nsteps))))

  message(date(), ": getEncDimRange", pars_q)

  psiType = "jaccard"
  impl = "PCA"

  fds <- saveFraserDataSet(fds, name="fds-normfalse")
  # Heatmap of the sample correlation
#  plotCountCorHeatmap(fds, type=psiType, logit=FALSE, normalized=FALSE)
  # Heatmap of the intron/sample expression
#  plotCountCorHeatmap(fds, type=psiType, logit=FALSE, normalized=FALSE, plotType="junctionSample", topJ=100, minDeltaPsi=0.05)

  #set.seed(as.integer(random))
  # hyperparameter opimization can be used to estimate the dimension q of the latent space of the data. 
  # It works by artificially injecting outliers into the data and then comparing the AUC of recalling these outliers for different values of q.
  fds <- optimHyperParams(fds, type=psiType, implementation=impl, q_param=pars_q, minDeltaPsi=0.05, plot=FALSE)
  # retrieve the estimated optimal dimension of the latent space
  #currentType(fds) <- psiType
  bestq = bestQ(fds, type=psiType)
  message(date(), "...find best q: " ,bestq)

  # Add verbosity to the FRASER object
  verbose(fds) <- 3
  fds <- fit(fds, q=bestq, type=psiType, implementation=impl, iterations=15)

  # Heatmap of the sample correlation
#  plotCountCorHeatmap(fds, type=psiType, logit=FALSE, normalized=TRUE)
  # Heatmap of the intron/sample expression
#  plotCountCorHeatmap(fds, type=psiType, logit=FALSE, normalized=TRUE, plotType="junctionSample", topJ=100, minDeltaPsi=0.05)
  dev.off()
  fds <- saveFraserDataSet(fds, name="fds-normtrue")

  #all in one getEncDimRange, optimHyperParams, bestQ, fit
  #fds_fraser <- FRASER(fds_filtered, q=c(jaccard=2))

  fds <- annotateRanges(fds, GRCh = 38)

  # Pvalues
  fds <- calculatePvalues(fds, type=psiType)
  # Adjust Pvalues
  fds <- calculatePadjValues(fds, type=psiType)

  fds <- saveFraserDataSet(fds, name="fds-final")

  return (fds)
}

write_fraser_output <- function(fraser_ds, prefix){
  # retrieve results with default and recommended cutoffs (padj <= 0.05 (0.1 gagneurlab) and # |deltaPsi| >= 0.3)
  fraser_res <- results(fraser_ds, all=TRUE)
  #res <- results(fds, psiType=psiTypes, aggregate=TRUE, collapse=FALSE, all=TRUE)
  message(date(), ": result...")
  print(fraser_res)

  write.table(as.data.frame(unname(fraser_res)), paste0("fraser_result_",prefix,".tsv"), sep="\t", quote=FALSE)
}


main <- function(args){
  ##Argument.Parser not in docker image..
  sample <- args[6] #: bam + bai sample of interest
  refset <- args[7] #: dir to ref set bams + bai
  prefix <- args[8] #: prefix
  pairedEnd <- args[9] #: pairedEnd (=TRUE)
  sampleTable <- create_sample_table(sample, refset, pairedEnd)
  message(date(), ": sampleTable")
  fraser_ds <- run_fraser(sampleTable)
  write_fraser_output(fraser_ds, prefix)
}


main(args)
