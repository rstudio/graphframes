print_newline <- function() {
  cat("", sep = "\n")
}

gf_algo_print_call <- function(algo) {
  printf("Call: %s\n", paste(deparse(algo$.call, width.cutoff = 500), collapse = " "))
  invisible(algo$.call)
}

print_param <- function(param_name, param) {
  paste0("  ", param_name, ": ", param)
}

#' @export
summary.gf_algo <- function(object, digits = max(3L, getOption("digits") - 3L), ...) {
  print(object, digits = digits)
  invisible(object)
}
