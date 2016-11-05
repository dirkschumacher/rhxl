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
  expect_false(is_valid_tag("1a#dm1+fr"))
})

test_that("schema_to_df converts a schema to df", {
  schema_vector <- c("#adm1", "#adm2 +code", "#meta+url +wikipedia")
  result <- schema_to_df(schema_vector) %>%
    dplyr::arrange(tag, attribute)
  expect_true(tibble::is.tibble(result))
  expect_equal(c("adm1", "adm2", "meta"), sort(unique(result$tag)))
  expect_equal(c(NA_character_, "code", "url", "wikipedia"), result$attribute)
  expect_equal(c(1, 2, 3, 3), result$column_idx)
})

test_that("schema_df_to_str converts a schema df to character", {
  schema_vector <- c(NA_character_, "#adm1",
                     "#adm2 +code", "#meta+url +wikipedia")
  s <- schema_to_df(schema_vector)
  result <- schema_df_to_str(4, s)
  expect_equal(c(NA_character_, "#adm1",
                 "#adm2 +code", "#meta +url +wikipedia"), result)
})

test_that("it warns if no tags are present", {
  expect_warning(as_hxl(cars))
})

test_that("it converts the cols into correct format", {
  result <- as_hxl(read.csv("samples/ws-airports.csv"))
  expect_true(is.integer(result$id))
  expect_true(is.character(result$ident))
})
