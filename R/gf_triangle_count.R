#' Computes the number of triangles passing through each vertex.
#' @template roxlate-gf-x
#' @template roxlate-gf-dots
#' @export
gf_triangle_count <- function(x, ...) {
  gf <- spark_graphframe(x)

  algo <- gf %>%
    invoke("triangleCount")

  result <- algo %>%
    invoke("run")

  gf_algo("triangle_count", algo,
          result = result,
          input = gf)
}

#' @export
print.gf_algo_triangle_count <- function(x, digits = max(3L, getOption("digits") - 3L), ...) {
  gf_algo_print_call(x)
  print_newline()

  cat(paste0("Result:"))
  print_newline()
  print(gf_algo_result(x))
}
