#' PageRank
#'
#' @template roxlate-gf-x
#' @param tol tolerance
#' @param reset_prob reset probability
#' @param max_iter maximum number of iterations
#' @param source_id (Optional) source vertex for a personalized pagerank
#' @template roxlate-gf-dots
#' @export
gf_pagerank <- function(x, tol = NULL, reset_prob = 0.15, max_iter = NULL,
                        source_id = NULL, ...) {
  ensure_scalar_double(tol, allow.null = TRUE)
  ensure_scalar_double(reset_prob)
  ensure_scalar_double(max_iter, allow.null = TRUE)
  ensure_scalar_character(source_id, allow.null = TRUE)

  gf <- spark_graphframe(x)

  if (is.null(tol) && is.null(max_iter))
    stop("One of 'tol' and 'max_iter' must be specified")
  if (!is.null(tol) && !is.null(max_iter))
    stop("You cannot specify both 'tol' and 'max_iter'")

  algo <- gf %>%
    invoke("pageRank") %>%
    invoke("resetProbability", reset_prob)

  if (!is.null(tol))
    algo <- invoke(algo, "tol", tol)

  if (!is.null(max_iter))
    algo <- invoke(algo, "maxIter", max_iter)

  if (!is.null(source_id))
    algo <- invoke(algo, "sourceId", source_id)

  result <- algo %>%
    invoke("run")

  params <- match.call()

  gf_algo("pagerank", algo,
          result = result,
          tol = tol,
          reset_prob = reset_prob,
          max_iter = max_iter,
          source_id = source_id,
          input = gf,
          params = params)

}

#' @export
print.gf_algo_pagerank <- function(x, digits = max(3L, getOption("digits") - 3L), ...) {
  gf_algo_print_call(x)
  print_newline()

  cat(paste0("Algo parameters:"),
      print_param("Tolerance", x$tol),
      print_param("Reset probability", x$reset_prob),
      print_param("Max iterations", x$max_iter),
      print_param("Source ID", x$source_id),
      sep = "\n")
  print_newline()
  cat(paste0("Result:"))
  print_newline()
  print(gf_algo_result(x))
}
