#' Shortest paths
#'
#' Computes shortest paths from every vertex to the given set of landmark vertices.
#'   Note that this takes edge direction into account.
#'
#' @template roxlate-gf-x
#' @param landmarks IDs of landmark vertices.
#' @template roxlate-gf-dots
#' @export
gf_shortest_paths <- function(x, landmarks, ...) {
  landmarks <- lapply(landmarks, ensure_scalar_character)

  gf <- spark_graphframe(x)

  algo <- gf %>%
    invoke("shortestPaths") %>%
    invoke("landmarks", landmarks)

  algo %>%
    invoke("run") %>%
    sdf_register()
}
