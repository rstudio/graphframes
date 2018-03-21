#' Computes the number of triangles passing through each vertex.
#'
#' This algorithm ignores edge direction; i.e., all edges are treated
#'   as undirected. In a multigraph, duplicate edges will be counted only once.
#'
#' @template roxlate-gf-x
#' @template roxlate-gf-dots
#' @export
gf_triangle_count <- function(x, ...) {
  gf <- spark_graphframe(x)

  algo <- gf %>%
    invoke("triangleCount")

  algo %>%
    invoke("run") %>%
    sdf_register()
}
