
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
            schema_df = schema_to_df(schema_definition),
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

# converts a schema df to a string
# params: ncols number of columns of the orig. data_frame
# params schema_df the schema as a data.frame
#' @importFrom utils head
schema_df_to_str <- function(ncols, schema_df) {
  stopifnot(tibble::is.tibble(schema_df))
  stopifnot(ncols >= 1)
  stopifnot(length(ncols) == 1)
  vapply(seq_len(ncols), function(x) {
    col_schema <- schema_df[schema_df$column_idx == x, ]
    if (nrow(col_schema) == 0) {
      NA_character_
    } else {
      tag <- head(col_schema$tag, 1)
      schema_attr <- col_schema$attribute
      no_attributes <- all(is.na(schema_attr))
      stopifnot(length(schema_attr) == 1 || !no_attributes)
      schema_attr <- if (no_attributes) {
        ""
      } else {
        paste0(" ", paste0(paste0("+", schema_attr), collapse = " "))
      }
      paste0("#", tag, schema_attr)
    }
  }, character(1))
}

schema_to_df <- function(schema_vector) {
  stopifnot(is.character(schema_vector))
  schema_vector <- stringr::str_to_lower(stringr::str_trim(schema_vector))
  schema <- (lapply(seq_len(length(schema_vector)), function(col_idx) {
    x <- schema_vector[col_idx]
    if (!is.na(x) && is_valid_tag(x)) {
      ptags <- parse_tag(x)
      data.frame(tag = ptags$tag, attribute = ptags$attributes,
                 column_idx = col_idx, stringsAsFactors = FALSE)
    } else {
      NULL
    }
  }))
  tibble::as_data_frame(dplyr::bind_rows(schema))
}

parse_tag <- function(tag) {
  stopifnot(length(tag) == 1)
  stopifnot(!is.na(tag) && is_valid_tag(tag))
  tags <- stringr::str_extract(tag, "^#[a-z][a-z0-9_]*")
  tags <- stringr::str_sub(tags, start = 2)
  attribute_pattern <- "\\+(\\s*[a-z][a-z0-9_]*)"
  attributes <- unlist(stringr::str_extract_all(tag, attribute_pattern))
  attributes <- stringr::str_sub(attributes, start = 2)
  if (length(attributes) == 0) {
    attributes <- NA_character_
  }
  list(tag = tags, attributes = attributes)
}
