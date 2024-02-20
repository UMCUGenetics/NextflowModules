#!/usr/bin/env Rscript

# Import statements, alphabetic order of main package.
suppressPackageStartupMessages(library("argparse"))
suppressPackageStartupMessages(library("OUTRIDER"))
suppressPackageStartupMessages(library("tools"))
suppressPackageStartupMessages(library("tibble"))
suppressPackageStartupMessages(library("readr"))
suppressPackageStartupMessages(library("dplyr"))

# Argument parser
parser <- ArgumentParser(description = "Process some integers")
parser$add_argument("query", metavar = "query_input_files", nargs = "+",
                    help = "Files or directories containing the query input files.")
parser$add_argument("-o","--output_path", metavar = "output_path", nargs = "+",
                    help = "Path where output of OUTRIDER will be stored.", default="./")
parser$add_argument("-r", "--ref", metavar = "reference_input_files", nargs = "+",
                    help = "Files or directories containing the reference input files.")
parser$add_argument("-f", "--feat", metavar = "feature", nargs = "+",
                    help = "Choose gene or exon level. Gene is default.", default="gene")
args <- parser$parse_args()


read_input_files <- function(input){
  sampleIDs <- c()
  count_tables <- lapply(input, function(f) {
    input_ext <- tools::file_ext(f)
    if(input_ext == "Rds") {
      rse <- readRDS(f)  # RangedSummarizedExperiment
      sampleIDs <- append(sampleIDs, colnames(rse))
      return(as_tibble(rownames_to_column(as.data.frame(assays(rse)$counts), var="rownames")))
    } else if (input_ext %in% c("txt", "tsv")) {
      count_table <- read_delim(f, show_col_types=FALSE, skip=1)
      # col 1: samples IDs, col 7: counts
      ct <- count_table[,c(1,7)]
      names(ct)[1] <- "rownames"
      sampleIDs <<- append(sampleIDs, colnames(ct)[2])
      return(ct)
    } else {
      stop("Input file extension is not supported.")
    }
  })
  return(list("sampleIDs"=sampleIDs, "count_tables"=count_tables))
}


get_input <- function(input){
  # If directories are provided
  if(all(sapply(input, function(x) dir.exists(x)))) {
    retrieved_files <- sapply(input, function(d){
      list.files(path = d, pattern = "Rds|txt|tsv", full.names = TRUE, recursive = FALSE)
    })
  } else if(all(sapply(input, function(x) file.exists(x)))) {  # If files are provided.
    retrieved_files <- input
  } else {  # If both dir and files are provided, or different tyes (character, int etc)
    stop("Input is neither dir or file.")
  }
  
  return(read_input_files(retrieved_files))
}


merge_count_tables <- function(lst_query, lst_ref){
  # merge count tables together.
  lst_count_tables <- c(lst_query, lst_ref)
  all_counts <- lst_count_tables %>%
    Reduce(function(dtf1,dtf2) dplyr::full_join(dtf1, dtf2,by="rownames"), .)
}


run_outrider <- function(all_counts) {
  # TODO: change to add to single object (ods) in case OOM, instead of renaming the vars.
  # filter expression
  all_counts_matrix <- as.matrix(all_counts)[,-1]
  mode(all_counts_matrix) <- "integer"
  rownames(all_counts_matrix) <- all_counts$rownames

  ods <- OutriderDataSet(countData=all_counts_matrix)
  filtered <- filterExpression(ods, minCounts = FALSE, filterGenes = FALSE, gtfFile="/hpc/diaggen/data/databases/gencode/gencode.v44.primary_assembly.basic.annotation.gtf")
  filtered <- filtered[mcols(filtered)$passedFilter,]
#  filtered <- filterExpression(ods, minCounts = TRUE, filterGenes = TRUE)

  ods <- estimateSizeFactors(filtered)
  print(ods$sizeFactor)

  ##Drop pipeline
  #maxTestedDimensionProportion 
  mp <- 3	 
  implementation <- "autoencoder"

  a <- 5 
  b <- min(ncol(ods), nrow(ods)) / mp   # N/3
  maxSteps <- 15
   if(mp < 4){
    maxSteps <- 20
  }

  Nsteps <- min(maxSteps, b)   # Do at most 20 steps or N/3
  # Do unique in case 2 were repeated

  pars_q <- round(exp(seq(log(a),log(b),length.out = Nsteps))) %>% unique
  #help suggestion:
  #pars_q <- seq(2, min(100, ncol(ods) - 1, nrow(ods) - 1), 2)
  print(pars_q)

  ods <- findEncodingDim(ods, params = pars_q, implementation = implementation, BPPARAM=MulticoreParam(8))

  print("getbestQ")
  opt_q <- getBestQ(ods)
  print(opt_q)

  ods <- controlForConfounders(ods, q=opt_q, implementation=implementation, BPPARAM=MulticoreParam(8))
  
  #exclude sample of interest from the fitting bc of possible replicates..
  #message(date(), ": sample Exclusion Mask ...")
  #sampleExclusionMask(ods) <- FALSE
  #sampleExclusionMask(ods[,c(1)]) <- TRUE

  #if(grepl("^(peer|pca)$", implementation)){ 
  #   message(date(), ": Fitting the data ...")
  #   ods <- fit(ods, BPPARAM=MulticoreParam(8))
  #}

  ods <- computePvalues(ods, alternative="two.sided", method="BY")
  out <- computeZscores(ods)

#  out <- OUTRIDER(filtered, BPPARAM=MulticoreParam(8))
  return(out)
}


save_output <- function(out_path, out_outrider, ref_samples, feature, padj_thres=0.05, zscore_thres=0, a=TRUE) {
  res <- as_tibble(results(out_outrider, padjCutoff=padj_thres, zScoreCutoff=zscore_thres, all=a))
  # Reference samples are excluded from final results. 
  #query_res <- filter(res, !(sampleID %in% ref_samples))
  query_res <- res
  # Write output table with aberrant expressed targets.
  write_tsv(query_res, paste0(out_path, "outrider_result_", feature, ".tsv"))
}


# TODO: investigate memory usage and if possible reduced / parallel.
main <- function(query, ref, output_path, feature){
  query_data <- get_input(query)
  ref_data <- get_input(ref)
  all_counts <- merge_count_tables(query_data$count_tables, ref_data$count_tables)
  output <- run_outrider(all_counts)
  save_output(output_path, output, ref_data$sampleIDs, feature)
}


main(args$query, args$ref, args$output_path, args$feat)