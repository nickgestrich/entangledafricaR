#' Michelsberg Phase 3 ceramics matrix
#'
#' A matrix showing the amount of ceramic types co-occurring between sites of Michelsberg Phase 3.
#'
#' @format A 24x24 symmetric matrix.
#'
#' @source \url{https://cran.r-project.org/web/packages/archdata/index.html}
"mbk3mat"


#' Michelsberg Phase 3 ceramics edgelist
#'
#' A dataframe representing a weighted edge list of ceramic co-occurrence in Michelsberg Phase 3.
#'
#' @format A data frame with 268 rows and 3 columns.
#' \describe{
#'   \item{from}{site name}
#'   \item{to}{site name}
#'   \item{weight}{number of shared ceramic types}
#' }
#' @source \url{https://cran.r-project.org/web/packages/archdata/index.html}
"mbk3edges"

#' Michelsberg Phase 3 ceramics node list
#'
#' A dataframe representing a node list of ceramic find contexts in Michelsberg Phase 3.
#'
#' @format A data frame with 24 rows and 5 columns.
#' \describe{
#'   \item{id}{site name and feature number}
#'   \item{site_name}{site name}
#'   \item{feature_nr}{feature number}
#'   \item{lon}{longitude}
#'   \item{lat}{latitude}
#' }
#' @source \url{https://cran.r-project.org/web/packages/archdata/index.html}
"mbk3nodes"
