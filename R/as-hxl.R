
#' @export
as_hxl <- function(x) {
  UseMethod("as_hxl", x)
}

#' @export
#' @rdname as_hxl
as_hxl.data.frame <- function(x) {
  convert_df_to_hxl(x)
}

convert_df_to_hxl <- function(x) {
  tbl <- tibble::as_tibble(x)
  schema_row <- find_schema_row(tbl)
  if (schema_row == -1) {
    warning("No schema found")
  }
  base_tbl <- if (schema_row > 0) {
    tbl[-schema_row, ]
  } else {
    tbl
  }
  structure(base_tbl, class = c("tbl_hxl", class(x)))
}

# returns a
find_schema_row <- function(tbl) {
  stopifnot(is.data.frame(tbl))
  if (all(is_valid_tag(colnames(tbl)))) {
    return(0)
  } else {
    for (i in seq_len(pmin(nrow(tbl), 25))) {
      row <- unlist(apply(tbl[i, ], 2, as.character))
      if (all(is_valid_tag(row))) {
        return(i)
      }
    }
  }
  -1
}

is_valid_tag <- function(tag) {
  ltag <- stringr::str_to_lower(stringr::str_trim(tag))
  pattern <- "^#[a-z][a-z0-9_]*(\\s+\\+\\s*[a-z][a-z0-9_]*)*"
  stringr::str_detect(ltag, pattern)
}
