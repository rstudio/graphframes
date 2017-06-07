printf <- function(fmt, ...) {
  cat(sprintf(fmt, ...))
}

"%||%" <- function(x, y) {
  if (is.null(x)) y else x
}
