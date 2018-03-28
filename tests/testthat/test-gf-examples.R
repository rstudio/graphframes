context("gf examples")

sc <- testthat_spark_connection()
test_requires("dplyr")

test_that("gf_star() works", {
  expect_known_output(
    gf_star(sc, n = 10),
    "output/gf_star.txt",
    print = TRUE
  )
})

test_that("gf_chain() works", {
  expect_known_output(
    gf_chain(sc, n = 5),
    "output/gf_chain.txt",
    print = TRUE
  )
})

test_that("gf_grid_ising_model() works", {
  grid_ising_model <- gf_grid_ising_model(sc, n = 5)
  expect_identical(
    grid_ising_model %>%
      gf_edge_columns(),
    c("src", "dst", "b")
    )
  expect_identical(
    grid_ising_model %>%
      gf_vertex_columns(),
    c("i", "j", "id", "a")
  )
})

test_that("gf_two_blobs() works", {
  expect_known_output(
    gf_two_blobs(sc, 2),
    "output/two_blobs.txt",
    print = TRUE
  )
})
