#' Breadth-first search (BFS)
#'
#' @template roxlate-gf-x
#'
#' @param from_expr Spark SQL expression specifying valid starting vertices for the BFS.
#' @param to_expr Spark SQL expression specifying valid target vertices for the BFS.
#' @param max_path_length Limit on the length of paths.
#' @param edge_filter Spark SQL expression specifying edges which may be used in the search.
#' @template roxlate-gf-dots
#'
#' @examples
#' \dontrun{
#' g <- gf_friends(sc)
#' gf_bfs(g, from_expr = "name = 'Esther'", to_expr = "age < 32")
#' }
#' @export
gf_bfs <- function(x,
                   from_expr,
                   to_expr,
                   max_path_length = 10L,
                   edge_filter = NULL, ...) {

  from_expr <- ensure_scalar_character(from_expr)
  to_expr <- ensure_scalar_character(to_expr)
  max_path_length <- ensure_scalar_integer(max_path_length)
  edge_filter <- ensure_scalar_character(edge_filter, allow.null = TRUE)

  gf <- spark_graphframe(x)

  algo <- gf %>%
    invoke("bfs")

  algo <- algo %>%
    invoke("fromExpr", from_expr) %>%
    invoke("toExpr", to_expr) %>%
    invoke("maxPathLength", max_path_length)

  if (!is.null(edge_filter))
    algo <- invoke(algo, "edgeFilter", edge_filter)

  algo %>%
    invoke("run") %>%
    sdf_register()
}
