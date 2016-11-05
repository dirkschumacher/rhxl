#' Get the HXL schema of an HXL tibble
#' @param x an HXL tibble
#' @return a tibble data_frame of the schema
#' @export
hxl_schema <- function(x) {
  stopifnot(is_hxl(x))
  attr(x, "schema")
}

#' Get the HXL schema of an HXL tibble as character
#' @param x an HXL tibble
#' @return a character in the same order as the columns
#' @export
hxl_schema_chr <- function(x) {
  stopifnot(is_hxl(x))
  schema_df_to_str(ncol(x), attr(x, "schema"))
}


#' Check if an object is an HXL tibble
#' @param x an object to test
#' @return true iff x is an HXL tibble
#' @export
is.hxl <- function(x) {
  "tbl_hxl" %in% class(x)
}

#' @export
#' @inheritParams  is.hxl
#' @rdname is.hxl
is_hxl <- is.hxl

#' Validate a HXL tbl against a schema pattern
#'
#' Currently does strict matching ignoring whitespaces.
#'
#' @param x an HXL tibble
#' @param schema_pattern a character vector
#'
#' @return TRUE if the schema pattern is part of the schema
#'
#' @examples
#' \dontrun{
#' some_dataset <- as_hxl(x)
#' validate(some_dataset, c("#adm1", "#adm2 + code"))
#' }
#' @export
hxl_validate <- function(x, schema_pattern) {
  stopifnot(is_hxl(x))
  stopifnot(is.character(schema_pattern))
  clean_pattern <- function(pattern) {
    stringr::str_replace_all(pattern,
                             "[\\s\\t]",
                             stringr::fixed(""))
  }
  cleaned_pattern <- clean_pattern(schema_pattern)
  all(cleaned_pattern %in% clean_pattern(hxl_schema_chr(x)))
}

#' Select a subset of columns by tags/attributes
#'
#' @param hxl an HXL table
#' @param tags a character vector of HXL tags
#'
#' It warns if a tag matches more columns.
#'
#' @return a data.frame in the order of the tags
#'
#' @export
hxl_select <- function(hxl, tags) {
  stopifnot(is_hxl(hxl))
  stopifnot(length(tags) >= 1 && is.character(tags))
  hxl_schema <- hxl_schema(hxl)
  col_idxes <- unique(unlist(lapply(tags, function(x) {
    stopifnot(!is.na(x) && is_valid_tag(x))
    ptag <- parse_tag(x)
    f_schema <- dplyr::group_by_(hxl_schema[hxl_schema$tag == ptag$tag, ],
                                .dots = "column_idx")
    if (!all(is.na(ptag$attributes))) {
      f_schema <- dplyr::filter_(f_schema, ~all(attribute %in% ptag$attributes))
    }
    as.integer(f_schema$column_idx)
  })))
  stopifnot(all(col_idxes >= 1) && all(col_idxes <= ncol(hxl)))
  if (length(tags) != length(col_idxes)) {
    warning("Tags matched multiple columns.")
  }
  hxl[, col_idxes]
}
