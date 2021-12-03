

#' Make an Edgelist.his function makes an edgelist out of an archaeological dataset by using the row names as nodes, and the rest of the columns as counts of types.
#'
#' @param data Dataset with nodes as row names
#'
#' @return A tibble
#' @export
#'
#' @importFrom magrittr %>%
#' @importFrom dplyr select
#' @importFrom dplyr mutate
#' @importFrom dplyr filter
#'
#' @examples
#'
#' # Make a dataset with  row names (nodes) as a separate column
make.edgelist <- function(data){

  data2 <- data %>%
    tibble::rownames_to_column(var = "node") %>%   # turn the rownames into a column for further processing
    select(node, tidyselect::everything())  #place the site variable at the beginning

  # Bring the data into long form, ready for co-presence
  datalong <- data2 %>%
    tidyr::pivot_longer(!node, names_to = "type") %>%  # turn the data into a long list
    mutate(value = dplyr::if_else(value>0.1, 1, 0))  # everything with a value is classed as present (1), otherwise as absent (0)

  # Get all the pairs of nodes
  nodes <- data2 %>%
    tidyr::expand(x = .[[1]], y = .[[1]]) %>%  # gets all possible pairs of sites
    filter(x != y)%>%  # removes those in which x = y
    dplyr::rowwise()%>%  # ready to select each row
    mutate(id = paste0(sort(c(x, y)), collapse = " ")) %>% #gives an id to every pairing
    dplyr::distinct(id, .keep_all = TRUE) %>%  #removes doubles
    select(-id)  # remove helper column

  # get all pottery types
  types <- tibble::tibble(type = colnames(data2[-1]))

  # create the finished datasets
  merge(nodes, types) %>%
    dplyr::left_join(datalong, by = c("x" = "node", "type" = "type"))%>%
    dplyr::left_join(datalong, by = c("y" = "node", "type" = "type")) %>%    #merge the data
    mutate(xy = value.x + value.y) %>%                            # add the pairs
    mutate(weight = dplyr::if_else(xy == 2, 1, 0)) %>%   # if there is a copresence (sum = 2), then a connection is made (1)
    select(-c(value.x, value.y, xy)) %>%  # remove the superfluous columns
    filter(weight > 0) %>%   # remove the rows without connections
    dplyr::group_by(from = pmin(x,y), to = pmax(x,y)) %>% # group data by node pairs
    dplyr::summarise(weight = sum(weight)) %>% # sum weights across all types
    tibble::as_tibble()
}
