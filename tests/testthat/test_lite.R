library(testthat)
library(rwos)
context("Lite API")

test_that("Authentication with wrong credentials fails", {
  expect_error({sid <- wos_authenticate(username = "aaa", password = "bbb")})
})

sid <- wos_authenticate()

test_that("Authentication without username and password is ok", {
  expect_true(is.character(sid) && nchar(sid) > 3)
})

res <- wos_search(sid, query = "AU=Wickham Hadley")

test_that("Search result object is correct", {
  expect_equal(res$sid, sid)
  expect_is(res$results, "numeric")
  expect_gt(res$results, 30)
  expect_is(res$id, "character")
})

test_that("Search with invalid syntax fails", {
  expect_error(wos_search(sid, query = "CUTR==yoyo"))
})

test_that("retrieve_all result is correct", {
  pubs <- wos_retrieve_all(res)
  expect_equal(nrow(pubs), res$results)
  expect_equal(ncol(pubs), 15)
  expect_match(as.character(pubs[1, "authors"]), "Wickham, Hadley")
})

Sys.sleep(2)
res <- wos_search(sid, "CU=Latvia")

test_that("retrieve result is correct", {
  pubs <- wos_retrieve(res, first = 532, count = 250)
  expect_equal(nrow(pubs), 250)
  expect_equal(ncol(pubs), 15)
})
