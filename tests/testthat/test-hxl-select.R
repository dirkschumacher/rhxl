context("hxl_select")

describe("hxl_select()", {
  base_data <- as_hxl(read.csv("samples/ws-airports.csv"))
  it("can match multiple tags/attributes", {
    expect_warning(result <- hxl_select(base_data, "#loc"))
    expect_equal(ncol(result), 6L)
    expect_true(nrow(result) > 0L)
  })
  it("warns if multiple tags match", {
    expect_warning(result <- hxl_select(base_data, "#loc"))
  })
  it("can match multiple tags/attributes 1", {
    result <- hxl_select(base_data, "#loc +airport +name")
    expect_equal(ncol(result), 1L)
    expect_true(nrow(result) > 0L)
  })
  it("can match multiple tags/attributes 2", {
    result <- hxl_select(base_data, "#loc +airport +code -local -iata")
    expect_equal(ncol(result), 1L)
    expect_true(nrow(result) > 0L)
  })
  it("can match a vector of tags", {
    expect_warning(result <- hxl_select(base_data,
                                        c("#loc +airport +code -local -iata",
                                          "#meta")))
    expect_equal(ncol(result), 7L)
    expect_true(nrow(result) > 0L)
  })
  it("warns if no cols selected", {
    expect_warning(result <- hxl_select(base_data, "#wat"))
    expect_equal(ncol(result), 0L)
    expect_equal(nrow(result), 0L)
  })
  it("returns a hxl_tbl with a subset of the schema", {
    result <- hxl_select(base_data, c("#geo +lat", "#geo +lon"))
    expect_equal(ncol(result), 2L)
    expect_true(nrow(result) > 0L)
    expect_equal(c("#geo+lat", "#geo+lon"), hxl_schema_chr(result))
  })
})
