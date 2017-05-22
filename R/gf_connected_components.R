#' Connected components
#'
#' @template roxlate-gf-x
#' @param broadcast_threshold broadcast threshold in propagating component assignments
#' @param algorithm 'graphframes' or 'graphx'
#' @param checkpoint_interval checkpoint interval in terms of number of iterations
#' @template roxlate-gf-dots
#' @export

gf_connected_components <- function(x,
                                    broadcast_threshold = 1000000L,
                                    algorithm = c("graphframes", "graphx"),
                                    checkpoint_interval = 2L, ...) {
  algorithm <- match.arg(algorithm)
  ensure_scalar_integer(broadcast_threshold)
  ensure_scalar_character(algorithm)
  ensure_scalar_integer(checkpoint_interval)

  gf <- spark_graphframe(x)

  algo <- gf %>%
    invoke("connectedComponents") %>%
    invoke("setBroadcastThreshold", broadcast_threshold) %>%
    invoke("setAlgorithm", algorithm) %>%
    invoke("setCheckpointInterval", checkpoint_interval)

  result <- algo %>%
    invoke("run")

  params <- match.call()

  gf_algo("connected_components", algo,
          result = result,
          broadcast_threshold = broadcast_threshold,
          algorithm = algorithm,
          checkpoint_interval = checkpoint_interval,
          input = gf,
          params = params)

}

#' @export
print.gf_algo_connected_components <- function(x, digits = max(3L, getOption("digits") - 3L), ...) {
  gf_algo_print_call(x)
  print_newline()

  cat(paste0("Algo parameters:"),
      print_param("Broadcast threshold", x$broadcast_threshold),
      print_param("Algorithm", x$algorithm),
      print_param("Checkpoing interval", x$checkpoing_interval),
      sep = "\n")
  print_newline()
  cat(paste0("Result:"))
  print_newline()
  print(gf_algo_result(x))
}
