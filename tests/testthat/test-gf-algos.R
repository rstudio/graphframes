context("gf algorithms")

sc <- testthat_spark_connection()
test_requires("dplyr")

test_that("gf_bfs() works", {
  expect_known_output(
    gf_friends(sc) %>%
      gf_bfs(from_expr = "name = 'Esther'", to_expr = "age < 32") %>%
      glimpse(),
    "output/gf_bfs.txt"
  )
})

test_that("gf_find() works", {
  expect_known_output(
    gf_friends(sc) %>%
      gf_find("(a)-[e]->(b); (b)-[e2]->(a)") %>%
      glimpse(),
    "output/gf_find.txt"
  )
})

test_that("gf_connected_components() works", {
  spark_set_checkpoint_dir(sc, tempdir())
  expect_known_output(
    gf_friends(sc) %>%
      gf_connected_components(),
    "output/gf_connected_components.txt"
  )
})

test_that("gf_scc() works", {
  expect_known_output(
    gf_friends(sc) %>%
      gf_scc(max_iter = 10),
    "output/gf_scc.txt"
  )
})

test_that("gf_pagerank() works", {
  expect_known_output(
    gf_friends(sc) %>%
      gf_pagerank(reset_probability = 0.15, tol = 0.01),
    "output/gf_pagerank.txt"
  )
})

test_that("gf_shortest_paths() works", {
  expect_known_output(
    gf_friends(sc) %>%
      gf_shortest_paths(landmarks = c("a", "d")),
    "output/gf_shortest_paths.txt"
  )
})

test_that("gf_triangle_count() works", {
  expect_known_output(
    gf_friends(sc) %>%
      gf_triangle_count(),
    "output/gf_triangle_count.txt"
  )
})

