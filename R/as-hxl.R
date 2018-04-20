
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
  schema_eq_colnames <- schema_row == 0L
  if (schema_row == -1) {
    warning("No schema found", call. = FALSE)
    schema_definition <- rep.int(NA_character_, ncol(x))
  } else if (schema_eq_colnames) {
    schema_definition <- colnames(x)
  }
  base_tbl <- if (schema_row > 0) {
    schema_definition <- as.character(apply(tbl[schema_row, ],
                                            2, as.character))
    new_tbl <- tbl[-1 * 1L:schema_row, ]
    new_tbl[] <- lapply(new_tbl, as.character)
    suppressMessages(readr::type_convert(new_tbl))
  } else {
    tbl
  }
  new_hxl_tbl(base_tbl, schema_to_df(schema_definition))
}

new_hxl_tbl <- function(base_data, schema_df) {
  structure(tibble::as_tibble(base_data),
            schema_df = schema_df,
            class = c("tbl_hxl", class(base_data)))
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
  ltag <- tolower(trimws(tag))
  pattern <- "^#[a-z][a-z0-9_]*(\\s+(\\+|-)\\s*[a-z][a-z0-9_]*)*"
  grepl(x = ltag, pattern = pattern)
}

# converts a schema df to a string
# params: ncols number of columns of the orig. data_frame
# params schema_df the schema as a data.frame
#' @importFrom utils head
schema_df_to_str <- function(ncols, schema_df) {
  stopifnot(tibble::is.tibble(schema_df))
  stopifnot(ncols >= 1L)
  stopifnot(length(ncols) == 1L)
  vapply(seq_len(ncols), function(x) {
    col_schema <- schema_df[schema_df$column_idx == x, ]
    if (nrow(col_schema) == 0) {
      NA_character_
    } else {
      tag <- head(col_schema$tag, 1L)
      schema_attr <- col_schema$attribute
      no_attributes <- all(is.na(schema_attr))
      stopifnot(length(schema_attr) == 1L || !no_attributes)
      schema_attr <- if (no_attributes) {
        ""
      } else {
        paste0(paste0("+", schema_attr), collapse = "")
      }
      paste0("#", tag, schema_attr)
    }
  }, character(1L))
}

schema_to_df <- function(schema_vector) {
  stopifnot(is.character(schema_vector))
  schema_vector <- tolower(trimws(schema_vector))
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
  tibble::as_data_frame(do.call(rbind, schema))
}

parse_tag <- function(tag) {
  stopifnot(length(tag) == 1)
  stopifnot(!is.na(tag) && is_valid_tag(tag))
  tags <- stringr::str_extract(tag, "^#[a-zA-Z][a-zA-Z0-9_]*")
  tags <- substr(tags, start = 2L, stop = nchar(tags))
  parse_attributes <- function(attribute_pattern) {
    attributes <- unlist(stringr::str_extract_all(tag, attribute_pattern))
    attributes <- substr(attributes, start = 2L, stop = nchar(attributes))
    if (length(attributes) == 0) {
      attributes <- NA_character_
    }
    attributes
  }
  attributes <- parse_attributes("\\+(\\s*[a-zA-Z][a-zA-Z0-9_]*)")
  excluded_attributes <- parse_attributes("-(\\s*[a-zA-Z][a-zA-Z0-9_]*)")
  list(tag = tags,
       attributes = attributes,
       excluded_attributes = excluded_attributes)
}
