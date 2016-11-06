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
})
