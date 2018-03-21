spark_dependencies <- function(spark_version, scala_version, ...) {
  spark_dependency(
    jars = c(
      system.file(
        sprintf("java/sparklygraphs-%s-%s.jar", spark_version, scala_version),
        package = "sparklygraphs"
      )
    ),
    packages = c(
      sprintf("graphframes:graphframes:0.5.0-spark%s-s_%s", spark_version, scala_version)
    )
  )
}

.onLoad <- function(libname, pkgname) {
  sparklyr::register_extension(pkgname)
}
