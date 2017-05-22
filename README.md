sparklygraphs: R interface for GraphFrames
================

```r
library(sparklygraphs)
library(dplyr)
sc <- spark_connect(master = "local", version = "2.1.0")
v <- data.frame(id = letters[1:7],
                name = c("Alice", "Bob", "Charlie", "David", "Esther",
                         "Fanny", "Gabby"))
e <- data.frame(src = c("a", "b", "c", "f", "e", "e", "d", "a"),
                dst = c("b", "c", "b", "c", "f", "d", "a", "e"))
v_tbl <- copy_to(sc, v)
e_tbl <- copy_to(sc, e)
g <- gf_graphframe(vertices = v_tbl, edges = e_tbl)
pr <- gf_pagerank(g, reset_prob = 0.15, max_iter = 10L, source_id = "a")
gf_algo_result(pr)
# Vertices
# # Source:   table<sparklyr_tmp_129731efa1c63> [?? x 3]
# # Database: spark_connection
# id    name   pagerank
# <chr>   <chr>      <dbl>
# 1     e  Esther 0.07527103
# 2     a   Alice 0.17710832
# 3     f   Fanny 0.03189214
# 4     g   Gabby 0.00000000
# 5     d   David 0.03189214
# 6     c Charlie 0.24655465
# 7     b     Bob 0.26993848
# 
# Edges
# # Source:   table<sparklyr_tmp_12973365db778> [?? x 3]
# # Database: spark_connection
# src   dst weight
# <chr> <chr>  <dbl>
# 1     b     c    1.0
# 2     c     b    1.0
# 3     d     a    1.0
# 4     e     f    0.5
# 5     a     e    0.5
# 6     a     b    0.5
# 7     e     d    0.5
# 8     f     c    1.0
```
