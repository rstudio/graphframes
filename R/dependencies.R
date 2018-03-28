spark_dependencies <- function(spark_version, scala_version, ...) {
  spark_dependency(
    jars = NULL,
    packages = c(
      sprintf("graphframes:graphframes:0.5.0-spark%s-s_%s", spark_version, scala_version)
    )
  )
}

.onLoad <- function(libname, pkgname) {
  sparklyr::register_extension(pkgname)
}
