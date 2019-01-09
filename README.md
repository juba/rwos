# R interface with Web of Science Web Services API

[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/rwos)](http://cran.r-project.org/package=rwos)

**Note :** Only the Lite version of the API is accessible for now.

## Installation

Not on CRAN, install directly from GitHub :

```r
install.packages("devtools")  # if required
devtools::install_github("juba/rwos")
```
    
## Usage

First, you need to authenticate against the service and get a session identifier. Username and password are not required as the Lite API is freely available.

```r
library(rwos)
sid <- wos_authenticate()
```
  
You can the use this session id to run search queries with `wos_search` :

```r
res <- wos_search(sid, "AU=Wickham Hadley")
```

This will display the number of results found. You can then retrieve all records from this search results with `wor_retrieve_all` :

```r
pubs <- wos_retrieve_all(res)
```

Or just a fraction of them with `wos_retrieve` :

```r
pubs <- wos_retrieve(res, first = 10, count = 15)
```

The result is a tibble (a data frame) with the different records fields as columns. 
    
## API usage

### API version

Only the Lite version of the API is accessible for now, which means :

- Access without authentication
- Limited set of returned data
- Records retrieving limited to batches of 100

### Collections

The search collections available with the lite API are SCI, ISTP, ISSHP, IC. You can narrow your search to a subset of those with the `editions` argument :

```r
wos_search(sid, 'TS=soil', editions = c("SCI", "IC"))
```

Queries against other editions will result in a `Not authorized` error message.

### Searching for exact several words expressions

When searching for text with a keyword like `TS`, you must enclose it into double quotes if you want to look for exact phrases. For example, the following search will look for the exact *soil health* expression :

```r
wos_search(sid, 'TS="soil health"')
```

Whereas the following will be equivalent to search for `(soil AND health)` :

```r
wos_search(sid, "TS='soil health'"")
```

### Limiting by document type

It seems you can narrow your search by document type with the `DT` operator, like this :

```r
wos_search(sid, "((TS=(soil AND health)) AND (DT=(Article OR Book OR Book Chapter)))")
```

This has not been well tested, so use it with caution and don't hesitate to report any issue.

## Links

Lite API technical documentation : http://ipscience-help.thomsonreuters.com/wosWebServicesLite/WebServicesLiteOverviewGroup/Introduction.html

General API FAQ : http://ip-science.interest.thomsonreuters.com/data-integration

Sample data : http://ip-science.interest.thomsonreuters.com/sample-data/?elqTrackId=4face30b453a4df981d9135a688b4868&elqaid=3746&elqat=2
