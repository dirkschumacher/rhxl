# rhxl
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/dirkschumacher/rhxl?branch=master&svg=true)](https://ci.appveyor.com/project/dirkschumacher/rhxl)
[![Travis-CI Build Status](https://travis-ci.org/dirkschumacher/rhxl.svg?branch=master)](https://travis-ci.org/dirkschumacher/rhxl)
[![Coverage Status](https://img.shields.io/codecov/c/github/dirkschumacher/rhxl/master.svg)](https://codecov.io/github/dirkschumacher/rhxl?branch=master)
[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/rhxl)](https://cran.r-project.org/package=rhxl)

Humanitarian Exchange Language in R (work in progress)

> HXL is a different kind of data standard, designed to improve information sharing during a humanitarian crisis without adding extra reporting burdens.
[hxlstandard.org](http://hxlstandard.org/standard/1_0final/)

## API

Currently a draft.

### as_hxl

`as_hxl`converts an object to an HXL data_frame. It returns a `tibble` with additional meta data for each column. 

```R
data <- as_hxl(readr::read_csv("treatment_centers.csv"))
```

### schema

Returns an informative object describing the schema of the dataset. Possibly a data_frame.

```R
schema(hxl_table)
```


### validate

Validate an HXL data_frame against a schema. Returns a boolean if it matches the schema.

```R
validate(hxl_table, c("#adm1", "#adm2", "#affected"))
```

