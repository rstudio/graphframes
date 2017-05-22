#' Create a GraphFrame Algorithm Object
#'
#' Create a GF algo object, wrapping the result of a GraphFrame routine call.
#' The generated object will be an \R list with S3 classes
#' \code{c("gf_algo_<class>", "gf_algo")}.
#'
#' @param class The name of the graph algorithm used. Note that the
#'   model name generated will be generated as \code{ml_model_<class>};
#'   that is, \code{gf_algo} will be prefixed.
#' @param algo The underlying GraphFrame algo object.
#' @param ... Additional algorithm information; typically supplied as named
#'   values.
#' @param .call The \R call used in generating this algo object (ie,
#'   the top-level \R routine that wraps over the associated GraphFrame
#'   routine). Typically used for print output in e.g. \code{print}
#'   and \code{summary} methods.
#'
#' @export
gf_algo <- function(class, algo, ..., .call = sys.call(sys.parent())) {
  object <- list(..., .call = .call, .algo = algo)
  class(object) <- c(
    paste("gf_algo", class, sep = "_"),
    "gf_algo"
  )
  object
}

#' Extracts the result of a GraphFrame algo run
#'
#' @param object a \code{gf_algo} object
#' @param ... additional arguments, currently not used
#'
#' @export
gf_algo_result <- function(object, ...) {
  jobj_class <- object$result %>%
    invoke("getClass") %>%
    invoke("toString")

  register <- switch(EXPR = jobj_class,
                  "class org.apache.spark.sql.Dataset" = sdf_register,
                  "class org.graphframes.GraphFrame" = gf_register)
  register(object$result)
}
