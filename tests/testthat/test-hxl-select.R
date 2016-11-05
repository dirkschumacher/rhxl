context("hxl_select")

describe("hxl_select()", {
  base_data <- as_hxl(read.csv("samples/ws-airports.csv"))
  it("can match multiple tags/attributes", {
    expect_warning(result <- hxl_select(base_data, "#loc"))
    expect_equal(6, ncol(result))
  })
  it("warns if multiple tags match", {
    expect_warning(result <- hxl_select(base_data, "#loc"))
  })
  it("can match multiple tags/attributes", {
    result <- hxl_select(base_data, "#loc +airport +name")
    expect_equal(1, ncol(result))
  })
})
