
<!-- README.md is generated from README.Rmd. Please edit that file -->
Humanitarian Exchange Language in R
===================================

[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/dirkschumacher/rhxl?branch=master&svg=true)](https://ci.appveyor.com/project/dirkschumacher/rhxl) [![Travis-CI Build Status](https://travis-ci.org/dirkschumacher/rhxl.svg?branch=master)](https://travis-ci.org/dirkschumacher/rhxl) [![Coverage Status](https://img.shields.io/codecov/c/github/dirkschumacher/rhxl/master.svg)](https://codecov.io/github/dirkschumacher/rhxl?branch=master) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/rhxl)](https://cran.r-project.org/package=rhxl)

The goal of this package is to provide functions to handle datasets with HXL tags. It is currently work in progress. If you have any ideas on how to further develop the package, please feel free to open an issue or a pull request.

> HXL is a different kind of data standard, designed to improve information sharing during a humanitarian crisis without adding extra reporting burdens. [hxlstandard.org](http://hxlstandard.org/standard/1_0final/)

Install
-------

To install the current development version use devtools:

``` r
devtools::install_github("dirkschumacher/rhxl")
```

API by Example
--------------

Read in the aiports of Viet Nam.

``` r
data_url <- "http://ourairports.com/countries/VN/airports.hxl"
hxl_data <- as_hxl(read.csv(data_url))
head(hxl_data)
#> # A tibble: 6 × 20
#>      id ident           type                               name
#>   <int> <chr>          <chr>                              <chr>
#> 1 26708  VVTS  large_airport Tan Son Nhat International Airport
#> 2 26700  VVNB  large_airport      Noi Bai International Airport
#> 3 26697  VVDN  large_airport      Da Nang International Airport
#> 4 26693  VVCR medium_airport                   Cam Ranh Airport
#> 5 26705  VVPQ medium_airport     Phu Quoc International Airport
#> 6 26702  VVPB medium_airport                    Phu Bai Airport
#> # ... with 16 more variables: latitude_deg <dbl>, longitude_deg <dbl>,
#> #   elevation_ft <int>, continent <chr>, iso_country <chr>,
#> #   iso_region <chr>, municipality <chr>, scheduled_service <int>,
#> #   gps_code <chr>, iata_code <chr>, local_code <chr>, home_link <chr>,
#> #   wikipedia_link <chr>, keywords <chr>, score <int>, last_updated <dttm>
```

You can get the schema as a tidy long table:

``` r
hxl_schema(hxl_data)
#> # A tibble: 35 × 3
#>      tag attribute column_idx
#>    <chr>     <chr>      <int>
#> 1   meta        id          1
#> 2   meta      code          2
#> 3    loc   airport          3
#> 4    loc      type          3
#> 5    loc   airport          4
#> 6    loc      name          4
#> 7    geo       lat          5
#> 8    geo       lon          6
#> 9    geo elevation          7
#> 10   geo        ft          7
#> # ... with 25 more rows
```

Or as a character vector in the order of the columns:

``` r
hxl_schema_chr(hxl_data)
#>  [1] "#meta +id"                  "#meta +code"               
#>  [3] "#loc +airport +type"        "#loc +airport +name"       
#>  [5] "#geo +lat"                  "#geo +lon"                 
#>  [7] "#geo +elevation +ft"        "#region +continent +code"  
#>  [9] "#country +code +iso2"       "#adm1 +code +iso"          
#> [11] "#loc +municipality +name"   "#status +scheduled"        
#> [13] "#loc +airport +code +gps"   "#loc +airport +code +iata" 
#> [15] "#loc +airport +code +local" "#meta +url +airport"       
#> [17] "#meta +url +wikipedia"      "#meta +keywords"           
#> [19] "#meta +score"               "#date +updated"
```

We can also test, if a dataset supports a schema. For example, we could test if the dataset has lat/lng coordinates.

``` r
hxl_validate(hxl_data, c("#geo +lat", "#geo +lon"))
#> [1] TRUE
```

With this information you could for example write a function that can automatically display a dataset on a map - without much configuration by the user. It also makes sharing of information easier.

In addition you can select certain columns based on tags:

``` r
hxl_select(hxl_data, c("#geo +lat", "#geo +lon"))
#> # A tibble: 47 × 2
#>    latitude_deg longitude_deg
#>           <dbl>         <dbl>
#> 1      10.81880      106.6520
#> 2      21.22120      105.8070
#> 3      16.04390      108.1990
#> 4      11.99820      109.2190
#> 5      10.16980      103.9931
#> 6      16.40150      107.7030
#> 7      12.22750      109.1920
#> 8      10.97670      106.8180
#> 9       8.73183      106.6330
#> 10     20.81940      106.7250
#> # ... with 37 more rows
```
