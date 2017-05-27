context("gf_interface")

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
