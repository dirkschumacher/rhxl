#' Get the HXL schema of an HXL tibble
#' @param x an HXL tibble
#' @return a tibble data_frame of the schema
#' @export
schema <- function(x) {
  stopifnot(is_hxl(x))
  attr(x, "schema")
}

#' Get the HXL schema of an HXL tibble as character
#' @param x an HXL tibble
#' @return a character in the same order as the columns
#' @export
schema_chr <- function(x) {
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
validate <- function(x, schema_pattern) {
  stopifnot(is_hxl(x))
  stopifnot(is.character(schema_pattern))
  clean_pattern <- function(pattern) {
    stringr::str_replace_all(pattern,
                             "[\\s\\t]",
                             stringr::fixed(""))
  }
  cleaned_pattern <- clean_pattern(schema_pattern)
  all(cleaned_pattern %in% clean_pattern(schema_chr(x)))
}


