library(testthat)
library(graphframes)

if (identical(Sys.getenv("NOT_CRAN"), "true")) {
  test_check("graphframes")
  on.exit({spark_disconnect_all()})
}
