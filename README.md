sparklygraphs: R interface for GraphFrames
================

-   Support for [GraphFrames](https://graphframes.github.io/) which aims to provide the functionality of [GraphX](http://spark.apache.org/graphx/).
-   Perform graph algorithms like: [PageRank](https://graphframes.github.io/api/scala/index.html#org.graphframes.lib.PageRank), [ShortestPaths](https://graphframes.github.io/api/scala/index.html#org.graphframes.lib.ShortestPaths) and many [others](https://graphframes.github.io/api/scala/#package).
-   Designed to work with [sparklyr](https://spark.rstudio.com) and the [sparklyr extensions](http://spark.rstudio.com/extensions.html).

Installation
------------

For those already using `sparklyr` simply run:

``` r
devtools::install_github("kevinykuo/sparklygraphs")
```

Otherwise, install first `sparklyr` from CRAN using:

``` r
install.packages("sparklyr")
```

The examples make use of the `highschool` dataset from the `ggplot` package.

Getting Started
---------------

We will calculate [PageRank](https://en.wikipedia.org/wiki/PageRank) over the `highschool` dataset as follows:

``` r
library(sparklygraphs)
library(sparklyr)
library(dplyr)

# connect to spark using sparklyr
sc <- spark_connect(master = "local", version = "2.1.0")

# copy highschool dataset to spark
highschool_tbl <- copy_to(sc, ggraph::highschool, "highschool")

# create a table with unique vertices using dplyr
vertices_tbl <- sdf_bind_rows(
  highschool_tbl %>% distinct(from) %>% transmute(id = from),
  highschool_tbl %>% distinct(to) %>% transmute(id = to)
)

# create a table with <source, destination> edges
edges_tbl <- highschool_tbl %>% transmute(src = from, dst = to)

gf_graphframe(vertices_tbl, edges_tbl) %>%
  gf_pagerank(reset_prob = 0.15, max_iter = 10L, source_id = "1")
```

    ## Call: gf_pagerank(., reset_prob = 0.15, max_iter = 10L, source_id = "1")
    ## 
    ## Algo parameters:
    ##   Tolerance: 
    ##   Reset probability: 0.15
    ##   Max iterations: 10
    ##   Source ID: 1
    ## 
    ## Result:
    ## Vertices
    ## # Source:   table<sparklyr_tmp_12784c26f9a2> [?? x 2]
    ## # Database: spark_connection
    ##       id    pagerank
    ##    <dbl>       <dbl>
    ##  1    12 0.012169139
    ##  2    12 0.012169139
    ##  3    59 0.001151867
    ##  4    59 0.001151867
    ##  5     1 0.155808486
    ##  6     1 0.155808486
    ##  7    20 0.035269712
    ##  8    20 0.035269712
    ##  9    45 0.023715824
    ## 10    45 0.023715824
    ## # ... with 127 more rows
    ## 
    ## Edges
    ## # Source:   table<sparklyr_tmp_1278452cf00e9> [?? x 3]
    ## # Database: spark_connection
    ##      src   dst     weight
    ##    <dbl> <dbl>      <dbl>
    ##  1    13     6 0.02777778
    ##  2    13     6 0.02777778
    ##  3    13     6 0.02777778
    ##  4    13     6 0.02777778
    ##  5    13     6 0.02777778
    ##  6    13     6 0.02777778
    ##  7    13     6 0.02777778
    ##  8    13     6 0.02777778
    ##  9    13     6 0.02777778
    ## 10    13     6 0.02777778
    ## # ... with 1.245e+04 more rows

Further Reading
---------------

Appart from calculating `PageRank` using `gf_pagerank`, the following functions are available:

-   gf\_bfs: Breadth-first search (BFS).
-   gf\_connected\_components: Connected components.
-   gf\_shortest\_paths: Shortest paths algorithm.
-   gf\_scc: Strongly connected components.
-   gf\_triangle\_count: Computes the number of triangles passing through each vertex and others.

For instance, one can calcualte the degrees of vertices using `gf_degrees` as follows:

``` r
gf_graphframe(vertices_tbl, edges_tbl) %>% gf_degrees()
```

    ## # Source:   table<sparklyr_tmp_127845eb8ff39> [?? x 2]
    ## # Database: spark_connection
    ##       id degree
    ##    <dbl>  <int>
    ##  1    55     25
    ##  2     6     10
    ##  3    13     16
    ##  4     7      6
    ##  5    12     11
    ##  6    63     21
    ##  7    58      8
    ##  8    41     19
    ##  9    48     15
    ## 10    59     11
    ## # ... with 60 more rows

In order to visualize large `sparklygraphs`, one can use `sample_n` and then use `ggraph` with `igraph` to visualize the graph as follows:

``` r
library(ggraph)
library(igraph)

graph <- highschool_tbl %>%
  sample_n(20) %>%
  collect() %>%
  graph_from_data_frame()

ggraph(graph, layout = 'kk') + 
    geom_edge_link(aes(colour = factor(year))) + 
    geom_node_point() + 
    ggtitle('An example')
```

![](tools/readme/unnamed-chunk-5-1.png)

Finally, we disconnect from Spark:

``` r
spark_disconnect(sc)
```
