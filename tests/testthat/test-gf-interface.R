context("gf interface")

sc <- testthat_spark_connection()
test_requires("dplyr")

v <- data_frame(id = 1:3, name = LETTERS[1:3])
e <- data_frame(src = c(1, 2, 2), dst = c(2, 1, 3),
                action = c("love", "hate", "follow"))
v_tbl <- testthat_tbl("v")
e_tbl <- testthat_tbl("e")

test_that("construction from DataFrame works", {
  g <- gf_graphframe(v_tbl, e_tbl)

  expect_equal(g %>% gf_vertices() %>% collect(), v)
  expect_equal(g %>% gf_edges() %>% collect(), e)
})

test_that("construction from edge frame works", {
  g <- gf_graphframe(edges = e_tbl)

  ids_from_vertices <- g %>%
    gf_vertices() %>%
    collect() %>%
    unlist(use.names = FALSE)

  ids_from_edges <- g %>%
    gf_edges() %>%
    collect() %>%
    select(src, dst) %>%
    unlist(use.names = FALSE) %>%
    unique()

  expect_true(setequal(ids_from_vertices, ids_from_edges))
})

test_that("printing graphframes", {
  expect_known_output(gf_friends(sc),
                      "output/friends.txt",
                      print = TRUE)
})

test_that("gf_triplets() works", {
  expect_known_output(
    gf_friends(sc) %>%
      gf_triplets() %>%
      collect() %>%
      glimpse(),
    "output/triplets.txt",
    print = TRUE,)
})

test_that("gf_vertex_columns() works", {
  expect_identical(
    gf_friends(sc) %>%
      gf_vertex_columns(),
    c("id", "name", "age")
  )
})

test_that("gf_edge_columns() works", {
  expect_identical(
    gf_friends(sc) %>%
      gf_edge_columns(),
    c("src", "dst", "relationship")
  )
})

test_that("gf_out_degrees() works", {
  expect_known_output(
    gf_friends(sc) %>%
      gf_out_degrees() %>%
      collect() %>%
      arrange(id),
    "output/gf_out_degrees.txt",
    print = TRUE
  )
})

test_that("gf_degrees() works", {
  expect_known_output(
    gf_friends(sc) %>%
      gf_degrees() %>%
      collect() %>%
      arrange(id),
    "output/gf_degrees.txt",
    print = TRUE
  )
})
