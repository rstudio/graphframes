#' Shortest paths
#'
#' Computes shortest paths from every vertex to the given set of landmark vertices.
#'   Note that this takes edge direction into account.
#'
#' @template roxlate-gf-x
#' @param landmarks IDs of landmark vertices.
#' @template roxlate-gf-dots
#'
#' @examples
#' \dontrun{
#' g <- gf_friends(sc)
#' gf_shortest_paths(g, landmarks = c("a", "d"))
#' }
#' @export
gf_shortest_paths <- function(x, landmarks, ...) {
  landmarks <- cast_string_list(landmarks)

  gf <- spark_graphframe(x)

  algo <- gf %>%
    invoke("shortestPaths") %>%
    invoke("landmarks", landmarks)

  algo %>%
    invoke("run") %>%
    sdf_register()
}
