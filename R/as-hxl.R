
#' Converts an object to an hxl data_frame
#' @param x the object
#' @return a hxl_tbl data_frame
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
  schema_eq_colnames <- schema_row == 0
  if (schema_row == -1) {
    warning("No schema found")
    schema_definition <- rep.int(NA_character_, ncol(x))
  } else if (schema_eq_colnames) {
    schema_definition <- colnames(x)
  }
  base_tbl <- if (schema_row > 0) {
    schema_definition <- as.character(apply(tbl[schema_row, ],
                                            2, as.character))
    new_tbl <- tbl[-schema_row, ]
    new_tbl[] <- lapply(new_tbl, as.character)
    suppressMessages(readr::type_convert(new_tbl))
  } else {
    tbl
  }
  structure(tibble::as_tibble(base_tbl),
            schema_vector = schema_definition,
            class = c("tbl_hxl", class(base_tbl)))
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
