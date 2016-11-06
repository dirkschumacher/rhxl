context("hxl_select")

describe("hxl_select()", {
  base_data <- as_hxl(read.csv("samples/ws-airports.csv"))
  it("can match multiple tags/attributes", {
    expect_warning(result <- hxl_select(base_data, "#loc"))
    expect_equal(6, ncol(result))
    expect_true(nrow(result) > 0)
  })
  it("warns if multiple tags match", {
    expect_warning(result <- hxl_select(base_data, "#loc"))
  })
  it("can match multiple tags/attributes 1", {
    result <- hxl_select(base_data, "#loc +airport +name")
    expect_equal(1, ncol(result))
    expect_true(nrow(result) > 0)
  })
  it("can match multiple tags/attributes 2", {
    result <- hxl_select(base_data, "#loc +airport +code -local -iata")
    expect_equal(1, ncol(result))
    expect_true(nrow(result) > 0)
  })
  it("can match a vector of tags", {
    expect_warning(result <- hxl_select(base_data,
                                        c("#loc +airport +code -local -iata",
                                          "#meta")))
    expect_equal(7, ncol(result))
    expect_true(nrow(result) > 0)
  })
  it("warns if no cols selected", {
    expect_warning(result <- hxl_select(base_data, "#wat"))
    expect_equal(0, ncol(result))
    expect_equal(0, nrow(result))
  })
  it("returns a hxl_tbl with a subset of the schema", {
    result <- hxl_select(base_data, c("#geo +lat", "#geo +lon"))
    expect_equal(2, ncol(result))
    expect_true(nrow(result) > 0)
    expect_equal(c("#geo +lat", "#geo +lon"), hxl_schema_chr(result))
  })
})
