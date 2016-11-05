context("schema")

test_that("one can get a schema of a HXL tibble", {
  result <- hxl_schema_chr(as_hxl(read.csv("samples/ws-airports.csv")))
  expect_equal(
    c("#meta +id", "#meta +code", "#loc +airport +type",
      "#loc +airport +name", "#geo +lat", "#geo +lon",
      "#geo +elevation +ft", "#region +continent +code",
      "#country +code +iso2", "#adm1 +code +iso",
      "#loc +municipality +name", "#status +scheduled",
      "#loc +airport +code +gps", "#loc +airport +code +iata",
      "#loc +airport +code +local", "#meta +url +airport",
      "#meta +url +wikipedia", "#meta +keywords", "#meta +score",
      "#date +updated"),
    result
  )
})

test_that("it works when schema is in colnames", {
  expected_schema <- c("#meta +id", "#meta +code", "#loc +airport +type",
    "#loc +airport +name", "#geo +lat", "#geo +lon",
    "#geo +elevation +ft", "#region +continent +code",
    "#country +code +iso2", "#adm1 +code +iso",
    "#loc +municipality +name", "#status +scheduled",
    "#loc +airport +code +gps", "#loc +airport +code +iata",
    "#loc +airport +code +local", "#meta +url +airport",
    "#meta +url +wikipedia", "#meta +keywords", "#meta +score",
    "#date +updated")
  x <- read.csv("samples/ws-airports.csv")
  x <- x[-1, ]
  colnames(x) <- expected_schema
  result <- hxl_schema_chr(as_hxl(x))
  expect_equal(expected_schema, result)
})

test_that("schema has always length equal to cols", {
  result <- suppressWarnings(hxl_schema_chr(as_hxl(cars)))
  expect_equal(rep.int(NA_character_, ncol(cars)), result)
})

test_that("schema returns a tibble", {
  result <- hxl_schema(as_hxl(read.csv("samples/ws-airports.csv")))
  expect_equal(35, nrow(result))
})
