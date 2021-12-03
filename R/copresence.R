#' Co-Presence - from Peeples 2017, http://mattpeeples.net/netstats.html. Creates a square matrix with 1 and 0 for presence and absence.
#'
#' @param x A dataset of count variables
#' @param thresh Threshold. Anything above this value will be counted as present.
#'
#' @return A matrix
#' @export
#'
#' @examples
#' co.p(df, thresh = 20)
co.p <- function(x, thresh = 0.1) {
  # create matrix of proportions
  temp <- prop.table(as.matrix(x), 1)
  # define anything with greater than or equal to 0.1 as present (1)
  temp[temp >= thresh] <- 1
  # define all other cells as absent (0)
  temp[temp < 1] <- 0
  # matrix algebraic calculation to find co-occurence (%*% indicates matrix
  # multiplication)
  out <- temp %*% t(temp)
  return(out)
}
