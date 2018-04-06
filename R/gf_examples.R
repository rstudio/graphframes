#' Graph of friends in a social network.
#'
#' @examples
#' \dontrun{
#' library(sparklyr)
#' sc <- spark_connect(master = "local")
#' gf_friends(sc)
#' }
#' @template roxlate-gf-sc
#' @export
gf_friends <- function(sc) {
  examples_graphs(sc) %>%
    invoke("friends") %>%
    gf_register()
}

#' Chain graph
#'
#' Returns a chain graph of the given size with Long ID type.
#'   The vertex IDs are 0, 1, ..., n-1, and the edges are (0, 1), (1, 2), ...., (n-2, n-1).
#' @template roxlate-gf-sc
#' @param n Size of the graph to return.
#' @examples
#' \dontrun{
#' gf_chain(sc, 5)
#' }
#' @export
gf_chain <- function(sc, n) {
  n <- ensure_scalar_integer(n)
  examples_graphs(sc) %>%
    invoke("chain", n) %>%
    gf_register()
}

#' Generate a grid Ising model with random parameters
#'
#' @details This method generates a grid Ising model with random parameters. Ising models
#'   are probabilistic graphical models over binary variables xi. Each binary
#'   variable xi corresponds to one vertex, and it may take values -1 or +1.
#'    The probability distribution P(X) (over all xi) is parameterized by
#'    vertex factors ai and edge factors bij:
#'
#'    \deqn{P(X) = (1/Z) * exp[ \sum_i a_i x_i + \sum_{ij} b_{ij} x_i x_j ]}
#'
#' @template roxlate-gf-sc
#' @param n Length of one side of the grid. The grid will be of size n x n.
#' @param v_std Standard deviation of normal distribution used to generate vertex factors "a". Default of 1.0.
#' @param e_std Standard deviation of normal distribution used to generate edge factors "b". Default of 1.0.
#'
#' @return GraphFrame. Vertices have columns "id" and "a". Edges have columns "src",
#'   "dst", and "b". Edges are directed, but they should be treated as undirected in
#'    any algorithms run on this model. Vertex IDs are of the form "i,j". E.g., vertex
#'    "1,3" is in the second row and fourth column of the grid.
#'
#' @examples
#' \dontrun{
#' gf_grid_ising_model(sc, 5)
#' }
#' @export
gf_grid_ising_model <- function(sc, n, v_std = 1, e_std = 1) {
  sql_context <- invoke_new(sc, "org.apache.spark.sql.SQLContext", spark_context(sc))
  n <- ensure_scalar_integer(n)
  v_std <- ensure_scalar_double(v_std)
  e_std <- ensure_scalar_double(e_std)

  examples_graphs(sc) %>%
    invoke("gridIsingModel", sql_context, n, v_std, e_std) %>%
    gf_register()
}

#' Generate a star graph
#'
#' Returns a star graph with Long ID type, consisting of a central element
#'    indexed 0 (the root) and the n other leaf vertices 1, 2, ..., n.
#' @template roxlate-gf-sc
#' @param n The number of leaves.
#'
#' @examples
#' \dontrun{
#' gf_star(sc, 5)
#' }
#' @export
gf_star <- function(sc, n) {
  n <- ensure_scalar_integer(n)

  examples_graphs(sc) %>%
    invoke("star", n) %>%
    gf_register()
}

#' Generate two blobs
#'
#' Two densely connected blobs (vertices 0->n-1 and n->2n-1)
#'   connected by a single edge (0->n).
#' @template roxlate-gf-sc
#' @param blob_size The size of each blob.
#'
#' @examples
#' \dontrun{
#' gf_two_blobs(sc, 3)
#' }
#' @export
gf_two_blobs <- function(sc, blob_size) {
  blob_size <- ensure_scalar_integer(blob_size)

  examples_graphs(sc) %>%
    invoke("twoBlobs", blob_size) %>%
    gf_register()
}

examples_graphs <- function(sc) {
  invoke_new(sc, "org.graphframes.examples.Graphs")
}
