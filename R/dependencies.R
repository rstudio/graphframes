spark_dependencies <- function(spark_version, scala_version, ...) {
  graphframes_version <- if (spark_version >= "3.1.0") {
    "0.8.2"
  } else if (spark_version >= "3.0.0") {
    "0.8.0"
  } else if (spark_version >= "2.4.0") {
    "0.7.0"
  } else if (spark_version >= "2.2.0") {
    "0.6.0"
  } else {
    "0.5.0"
  }

  spark_dependency(
    jars = NULL,
    packages = c(
      sprintf(
        "graphframes:graphframes:%s-spark%s-s_%s",
        graphframes_version,
        spark_version,
        scala_version
      )
    )
  )
}

.onLoad <- function(libname, pkgname) {
  sparklyr::register_extension(pkgname)
}
