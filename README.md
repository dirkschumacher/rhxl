# rhxl
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

