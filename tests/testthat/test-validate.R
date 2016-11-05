context("validate")

test_that("it can validate a schema", {
  x <- as_hxl(read.csv("samples/ws-airports.csv"))
  expect_true(hxl_validate(x, c("#adm1+code+iso")))
  expect_false(hxl_validate(x, c("#adm1+code")))
  expect_true(hxl_validate(x, c("#adm1  +code +iso", "#country +code +iso2")))
})
