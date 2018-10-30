#' Retrieve a GraphFrame
#'
#' @rdname spark_graphframe
#'
#' @param ... additional arguments, not used
#' @export
spark_graphframe <- function(x, ...) {
  UseMethod("spark_graphframe")
}

#' @rdname spark_graphframe
#' @template roxlate-gf-x
#' @export
spark_graphframe <- function(x, ...) {
  x$.jobj
}

new_graphframe <- function(jobj) {
  structure(
    list(
      vertices = jobj %>%
        invoke("vertices") %>%
        sdf_register(),
      edges = jobj %>%
        invoke("edges") %>%
        sdf_register(),
      .jobj = jobj
    ),
    class = "graphframe"
  )
}

#' Create a new GraphFrame
#'
#' @param vertices A \code{tbl_spark} representing vertices.
#' @param edges A \code{tbl_psark} representing edges.
#'
#' @examples
#' \dontrun{
#' library(sparklyr)
#' sc <- spark_connect(master = "local", version = "2.3.0")
#' v_tbl <- sdf_copy_to(
#'   sc, data.frame(id = 1:3, name = LETTERS[1:3])
#' )
#' e_tbl <- sdf_copy_to(
#'   sc, data.frame(src = c(1, 2, 2), dst = c(2, 1, 3),
#'                  action = c("love", "hate", "follow"))
#' )
#' gf_graphframe(v_tbl, e_tbl)
#' gf_graphframe(edges = e_tbl)
#' }
#' @export
gf_graphframe <- function(vertices = NULL, edges) {
  sc <- edges %>%
    spark_dataframe() %>%
    spark_connection()

  jobj <- if (is.null(vertices)) {
    invoke_static(sc,
                  "org.graphframes.GraphFrame",
                  "fromEdges",
                  spark_dataframe(edges))
  } else {
    invoke_new(sc,
               "org.graphframes.GraphFrame",
               spark_dataframe(vertices),
               spark_dataframe(edges))
  }

  new_graphframe(jobj)
}

#' @export
print.graphframe <- function(x, ...) {
  extract_and_print <- function(x) {
    output <- utils::capture.output(x)
    extracted_output <- paste0("  ",
           output[3:length(output)])
    cat(extracted_output, sep = "\n")
  }
  cat("GraphFrame\n")
  cat("Vertices:", sep = "\n")
  extract_and_print(tibble::glimpse(x$vertices))
  cat("Edges:", sep = "\n")
  extract_and_print(tibble::glimpse(x$edges))
  invisible(x)
}

#' Extract vertices DataFrame
#' @template roxlate-gf-x
#' @export
gf_vertices <- function(x) {
  x$vertices
}

#' Extract edges DataFrame
#' @template roxlate-gf-x
#' @export
gf_edges <- function(x) {
  x$edges
}

#' Triplets of graph
#'
#' @template roxlate-gf-x
#' @export
gf_triplets <- function(x) {
  x %>%
    spark_graphframe() %>%
    invoke("triplets") %>%
    sdf_register()
}

#' Register a GraphFrame object
#'
#' @template roxlate-gf-x
#' @export
gf_register <- function(x) {
  UseMethod("gf_register")
}

#' @export
gf_register.spark_jobj <- function(x) {
  new_graphframe(x)
}

#' @export
gf_register.graphframe <- function(x) {
  x
}

#' Vertices column names
#'
#' @template roxlate-gf-x
#' @export
gf_vertex_columns <- function(x) {
  x %>%
    spark_graphframe() %>%
    invoke("vertexColumns") %>%
    unlist()
}

#' Edges column names
#'
#' @template roxlate-gf-x
#' @export
gf_edge_columns <- function(x) {
  x %>%
    spark_graphframe() %>%
    invoke("edgeColumns") %>%
    unlist()
}

#' Out-degrees of vertices
#'
#' @template roxlate-gf-x
#' @export
gf_out_degrees <- function(x) {
  x %>%
    spark_graphframe() %>%
    invoke("outDegrees") %>%
    sdf_register()
}

#' In-degrees of vertices
#'
#' @template roxlate-gf-x
#' @export
gf_in_degrees <- function(x) {
  x %>%
    spark_graphframe() %>%
    invoke("inDegrees") %>%
    sdf_register()
}

#' Degrees of vertices
#'
#' @template roxlate-gf-x
#' @export
gf_degrees <- function(x) {
  x %>%
    spark_graphframe() %>%
    invoke("degrees") %>%
    sdf_register()
}

#' Motif finding: Searching the graph for structural patterns
#'
#' Motif finding uses a simple Domain-Specific Language (DSL) for
#'  expressing structural queries. For example,
#'  gf_find(g, "(a)-[e]->(b); (b)-[e2]->(a)") will search for
#'  pairs of vertices a,b connected by edges in both directions.
#'  It will return a DataFrame of all such structures in the graph,
#'  with columns for each of the named elements (vertices or edges)
#'  in the motif. In this case, the returned columns will be in
#'  order of the pattern: "a, e, b, e2."
#'
#' @template roxlate-gf-x
#'
#' @param pattern pattern specifying a motif to search for
#'
#' @examples
#' \dontrun{
#' gf_friends(sc) %>%
#'   gf_find("(a)-[e]->(b); (b)-[e2]->(a)")
#' }
#' @export
gf_find <- function(x, pattern) {
  pattern <- cast_string(pattern)

  x %>%
    spark_graphframe() %>%
    invoke("find", pattern) %>%
    sdf_register()
}

#' Cache the GraphFrame
#'
#' @template roxlate-gf-x
#'
#' @export
gf_cache <- function(x) {
  x %>%
    spark_graphframe() %>%
    invoke("cache") %>%
    gf_register()
}

#' Persist the GraphFrame
#'
#' @template roxlate-gf-x
#'
#' @param storage_level The storage level to be used. Please view the
#'   \href{http://spark.apache.org/docs/latest/programming-guide.html#rdd-persistence}{Spark Documentation}
#'   for information on what storage levels are accepted.
#'
#' @export
gf_persist <- function(x, storage_level = "MEMORY_AND_DISK") {
  storage_level <- cast_string(storage_level)
  gf <- spark_graphframe(x)
  storage_level <- invoke_static(
    spark_connection(gf),
    "org.apache.spark.storage.StorageLevel",
    storage_level
  )

  gf %>%
    invoke("persist", storage_level) %>%
    gf_register()
}

#' Unpersist the GraphFrame
#'
#' @template roxlate-gf-x
#'
#' @param blocking whether to block until all blocks are deleted
#'
#' @export
gf_unpersist <- function(x, blocking = FALSE) {
  blocking <- cast_scalar_logical(blocking)

  x %>%
    spark_graphframe() %>%
    invoke("unpersist", blocking) %>%
    gf_register()
}

