context("as_hxl")
test_that("can parse the airports sample", {
  expect_silent(result <- as_hxl(read.csv("samples/ws-airports.csv")))
  expect_equal(4, nrow(result))
  expect_s3_class(result, "tbl_hxl")
})

test_that("find_schema_row can detect schema row", {
  tbl <- tibble::as_tibble(read.csv("samples/ws-airports.csv"))
  expect_equal(1, find_schema_row(tbl))
})

test_that("is_valid_tag can detect a tag", {
  expect_true(is_valid_tag("#adm1"))
  expect_true(is_valid_tag("#adm1+fr"))
  expect_true(is_valid_tag("  #adm1+fr  "))
  expect_true(is_valid_tag("#meta +url +wikipedia"))
  expect_false(is_valid_tag("#1adm1+fr"))
  expect_false(is_valid_tag("1a#dm1+fr"))
})
