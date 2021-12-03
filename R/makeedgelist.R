# This function makes an edgelist out of an archaeological dataset by using the row names as nodes, and the rest of the columns as counts of types.

# Make a dataset with  row names (sites) as a separate column
make.edgelist <- function(data){

  data2 <- data %>%
    rownames_to_column(var = "node") %>%   # turn the rownames into a column for further processing
    select(node, everything())  #place the site variable at the beginning

  # Bring the data into long form, ready for co-presence
  datalong <- data2 %>%
    pivot_longer(!node, names_to = "type") %>%  # turn the data into a long list
    mutate(value = if_else(value>0.1, 1, 0))  # everything with a value is classed as present (1), otherwise as absent (0)

  # Get all the pairs of nodes
  nodes <- data2 %>%
    expand(x = .[[1]], y = .[[1]]) %>%  # gets all possible pairs of sites
    filter(x != y)%>%  # removes those in which x = y
    rowwise()%>%  # ready to select each row
    mutate(id = paste0(sort(c(x, y)), collapse = " ")) %>% #gives an id to every pairing
    distinct(id, .keep_all = TRUE) %>%  #removes doubles
    select(-id)  # remove helper column

  # get all pottery types
  types <- tibble(type = colnames(data2[-1]))

  # create the finished datasets
  merge(nodes, types) %>%
    left_join(datalong, by = c("x" = "node", "type" = "type"))%>%
    left_join(datalong, by = c("y" = "node", "type" = "type")) %>%    #merge the data
    mutate(xy = value.x + value.y) %>%                            # add the pairs
    mutate(weight = if_else(xy == 2, 1, 0)) %>%   # if there is a copresence (sum = 2), then a connection is made (1)
    select(-c(value.x, value.y, xy)) %>%  # remove the superfluous columns
    filter(weight > 0) %>%   # remove the rows without connections
    group_by(from = pmin(x,y), to = pmax(x,y)) %>% # group data by node pairs
    summarise(weight = sum(weight)) %>% # sum weights across all types
    as_tibble()
}
