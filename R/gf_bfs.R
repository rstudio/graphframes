#' Breadth-first search (BFS)
#'
#' @template roxlate-gf-x
#'
#' @param from Spark SQL expression specifying valid starting vertices for the BFS.
#' @param to Spark SQL expression specifying valid target vertices for the BFS.
#' @param max_path_length Limit on the length of paths.
#' @param edge_filter Spark SQL expression specifying edges which may be used in the search.
#' @template roxlate-gf-dots
#'
#' @export
gf_bfs <- function(x,
                   from,
                   to,
                   max_path_length = 10L,
                   edge_filter = NULL, ...) {

  ensure_scalar_character(from)
  ensure_scalar_character(to)
  ensure_scalar_integer(max_path_length)
  ensure_scalar_character(edge_filter, allow.null = TRUE)

  gf <- spark_graphframe(x)

  algo <- gf %>%
    invoke("bfs")

  algo <- algo %>%
    invoke("fromExpr", from) %>%
    invoke("toExpr", to) %>%
    invoke("maxPathLength", max_path_length)

  if (!is.null(edge_filter))
    algo <- invoke(algo, "edgeFilter", edge_filter)

  result <- algo %>%
    invoke("run")

  params <- match.call()

  gf_algo("bfs", algo,
          result = result,
          from = from,
          to = to,
          max_path_length = max_path_length,
          edge_filter = edge_filter,
          input = gf,
          params = params)
}

#' @export
print.gf_algo_bfs <- function(x, digits = max(3L, getOption("digits") - 3L), ...) {
  gf_algo_print_call(x)
  print_newline()

  cat(paste0("Algo parameters:"),
      print_param("From", x$from),
      print_param("To", x$to),
      print_param("Max path length", x$max_path_length),
      print_param("Edge filter", x$edge_filter),
      sep = "\n")
  print_newline()
  cat(paste0("Result:"))
  print_newline()
  print(gf_algo_result(x))
}
