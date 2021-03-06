% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/schema.R
\name{hxl_validate}
\alias{hxl_validate}
\title{Validate a HXL tbl against a schema pattern}
\usage{
hxl_validate(x, schema_pattern)
}
\arguments{
\item{x}{an HXL tibble}

\item{schema_pattern}{a character vector}
}
\value{
TRUE if the schema pattern is part of the schema
}
\description{
Currently does strict matching ignoring whitespaces.
}
\examples{
\dontrun{
some_dataset <- as_hxl(x)
validate(some_dataset, c("#adm1", "#adm2 +code"))
}
}
