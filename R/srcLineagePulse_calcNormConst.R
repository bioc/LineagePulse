#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#
#++++++++++++++++++++++#     Compute Size factors    ++++++++++++++++++++++++++#
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++#

#' Compute size factors for a scRNA-seq dataset
#' 
#' This function computes size factors for each sample
#' in the dataset and expands them to a matrix of the size
#' of the dataset.
#' Size factors scale the negative binomial likelihood
#' model of a gene to the sequencing depth of each sample.
#' Size factors are normalised relative sequencing depth of 
#' each cell. Note that size factors are usually differently computed
#' for bulk data (c.f. ImpulseDE2) but this procedure might
#' be unstable for single-cell data.
#' 
#' @seealso Called by \code{runLineagePulse}.
#' 
#' @param matCountsProc: (matrix genes x samples)
#'    Count data.
#' 
#' @return vecNormConst: (numeric vector number of cells) 
#'    Model scaling factors for each observation which take
#'    sequencing depth into account (size factors). One size
#'    factor per cell.
#' @export

calcNormConst <- function(matCountsProc){
  
  boolUseDepth <- FALSE
  if(boolUseDepth){
    # Size factors directly represent sequencing depth:
    # Normalised relative sequencing depth.
    vecSeqDepth <- apply(matCountsProc, 2,
      function(cell){ sum(cell, na.rm=TRUE) })
    vecNormConst <- vecSeqDepth/sum(vecSeqDepth)*length(vecSeqDepth)
    names(vecNormConst) <- colnames(matCountsProc)
  } else {
    print("All size factors set to one.")
    vecNormConst <- array(1, dim(matCountsProc)[2])
    names(vecNormConst) <- colnames(matCountsProc)
  }
  
  if(any(vecNormConst==0)){
    warning("WARNING IN LINEAGEPULSE: Found size factors==0, setting these to 1.")
    vecNormConst[vecNormConst==0] <- 1
  }
  
  return(vecNormConst)
}