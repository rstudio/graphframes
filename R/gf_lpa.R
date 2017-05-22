#' Label propagation algorithm (LPA)
#'
#' @template roxlate-gf-x
#' @param max_iter maximum number of iterations
#' @template roxlate-gf-dots
#' @export
gf_lpa <- function(x, max_iter, ...) {
  ensure_scalar_integer(max_iter)

  gf <- spark_graphframe(x)

  algo <- gf %>%
    invoke("labelPropagation") %>%
    invoke("maxIter", max_iter)

  result <- algo %>%
    invoke("run")

  params <- match.call()

  gf_algo("lpa", algo,
          result = result,
          max_iter = max_iter,
          input = gf,
          params = params)
}

#' @export
print.gf_algo_lpa <- function(x, digits = max(3L, getOption("digits") - 3L), ...) {
  gf_algo_print_call(x)
  print_newline()

  cat(paste0("Algo parameters:"),
      print_param("Max iterations", x$max_iter),
      sep = "\n")
  print_newline()
  cat(paste0("Result:"))
  print_newline()
  print(gf_algo_result(x))
}
