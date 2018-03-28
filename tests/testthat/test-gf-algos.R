context("gf algorithms")

sc <- testthat_spark_connection()
test_requires("dplyr")

test_that("gf_bfs() works", {
  expect_known_output(
    gf_friends(sc) %>%
      gf_bfs(from_expr = "name = 'Esther'", to_expr = "age < 32") %>%
      collect() %>%
      glimpse(),
    "output/gf_bfs.txt",
    print = TRUE
  )
})

test_that("gf_find() works", {
  expect_known_output(
    gf_friends(sc) %>%
      gf_find("(a)-[e]->(b); (b)-[e2]->(a)") %>%
      collect() %>%
      glimpse(),
    "output/gf_find.txt",
    print = TRUE
  )
})

test_that("gf_connected_components() works", {
  spark_set_checkpoint_dir(sc, tempdir())
  expect_identical(
    gf_friends(sc) %>%
      gf_connected_components() %>%
      pull(component) %>%
      unique() %>%
      length(),
    2L
  )
})

test_that("gf_scc() works", {
  expect_identical(
    gf_friends(sc) %>%
      gf_scc(max_iter = 10) %>%
      pull(component) %>%
      unique() %>%
      length(),
    4L
  )
})

test_that("gf_pagerank() works", {
  expect_known_output(
    gf_friends(sc) %>%
      gf_pagerank(reset_probability = 0.15, tol = 0.01) %>%
      gf_vertices() %>%
      collect() %>%
      arrange(id, name),
    "output/gf_pagerank.txt",
    print = TRUE
  )
})

test_that("gf_shortest_paths() works", {
  expect_known_output(
    gf_friends(sc) %>%
      gf_shortest_paths(landmarks = c("a", "d")) %>%
      collect() %>%
      arrange(id, name),
    "output/gf_shortest_paths.txt",
    print = TRUE
  )
})

test_that("gf_triangle_count() works", {
  expect_known_output(
    gf_friends(sc) %>%
      gf_triangle_count() %>%
      collect() %>%
      arrange(id, name),
    "output/gf_triangle_count.txt",
    print = TRUE
  )
})

test_that("gf_lpa() works", {
  lpa_result <- gf_friends(sc) %>%
    gf_lpa(max_iter = 5) %>%
    collect()
  expect_identical(dim(lpa_result),
                   c(7L, 4L))
  expect_identical(names(lpa_result),
                   c("id", "name", "age", "label"))
})

