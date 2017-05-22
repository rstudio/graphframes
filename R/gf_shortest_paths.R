#' Shortest paths
#'
#' @template roxlate-gf-x
#' @param landmarks IDs of landmark verticdes
#' @template roxlate-gf-dots
#' @export
gf_shortest_paths <- function(x, landmarks, ...) {
  lapply(landmarks, ensure_scalar_character)

  gf <- spark_graphframe(x)

  algo <- gf %>%
    invoke("shortestPaths") %>%
    invoke("landmarks", as.list(landmarks))

  result <- algo %>%
    invoke("run")

  params <- match.call()

  gf_algo("shortest_paths", algo,
          result = result,
          landmarks = landmarks,
          input = gf,
          params = params)
}

#' @export
print.gf_algo_shortest_paths <- function(x, digits = max(3L, getOption("digits") - 3L), ...) {
  gf_algo_print_call(x)
  print_newline()

  cat(paste0("Algo parameters:"),
      print_param("Landmarks", x$landmarks),
      sep = "\n")
  print_newline()
  cat(paste0("Result:"))
  print_newline()
  print(gf_algo_result(x))
}

