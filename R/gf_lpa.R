#' Label propagation algorithm (LPA)
#'
#' Run static Label Propagation for detecting communities in networks. Each node in the
#'   network is initially assigned to its own community. At every iteration, nodes send
#'   their community affiliation to all neighbors and update their state to the mode
#'   community affiliation of incoming messages. LPA is a standard community detection
#'    algorithm for graphs. It is very inexpensive
#'   computationally, although (1) convergence is not guaranteed and (2) one can
#'   end up with trivial solutions (all nodes are identified into a single community).
#'
#' @template roxlate-gf-x
#' @param max_iter Maximum number of iterations.
#' @template roxlate-gf-dots
#'
#' @examples
#' \dontrun{
#' g <- gf_friends(sc)
#' gf_lpa(g, max_iter = 5)
#' }
#' @export
gf_lpa <- function(x, max_iter, ...) {
  max_iter <- cast_scalar_integer(max_iter)

  gf <- spark_graphframe(x)

  algo <- gf %>%
    invoke("labelPropagation") %>%
    invoke("maxIter", max_iter)

  algo %>%
    invoke("run") %>%
    sdf_register()
}
