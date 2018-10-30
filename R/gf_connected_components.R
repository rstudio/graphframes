#' Connected components
#'
#' Computes the connected component membership of each vertex and returns a DataFrame
#'    of vertex information with each vertex assigned a component ID.
#'
#' @template roxlate-gf-x
#' @param broadcast_threshold Broadcast threshold in propagating component assignments.
#' @param algorithm One of 'graphframes' or 'graphx'.
#' @param checkpoint_interval Checkpoint interval in terms of number of iterations.
#' @template roxlate-gf-dots
#' @examples
#' \dontrun{
#' # checkpoint directory is required for gf_connected_components()
#' spark_set_checkpoint_dir(sc, tempdir())
#' g <- gf_friends(sc)
#' gf_connected_components(g)
#' }
#' @export
gf_connected_components <- function(x,
                                    broadcast_threshold = 1000000L,
                                    algorithm = c("graphframes", "graphx"),
                                    checkpoint_interval = 2L, ...) {
  algorithm <- match.arg(algorithm)
  broadcast_threshold <- cast_scalar_integer(broadcast_threshold)
  checkpoint_interval <- cast_scalar_integer(checkpoint_interval)

  gf <- spark_graphframe(x)

  algo <- gf %>%
    invoke("connectedComponents") %>%
    invoke("setBroadcastThreshold", broadcast_threshold) %>%
    invoke("setAlgorithm", algorithm) %>%
    invoke("setCheckpointInterval", checkpoint_interval)

  algo %>%
    invoke("run") %>%
    sdf_register()
}
