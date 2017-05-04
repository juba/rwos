#' @export
#' @import xml2

wos_authenticate <- function(username = NULL, password = NULL) {

  headers <- c(
    Accept = "multipart/*",
    'Content-Type' = "text/xml; charset=utf-8",
    SOAPAction = ""
  )
  if (!is.null(username) && !is.null(password)) {
    auth <- RCurl::base64(paste(username, password, sep = ":"))
    headers <- c(headers,
                 Authorization = paste0("Basic ", auth)
                 )
  }

  url <- "http://search.webofknowledge.com/esti/wokmws/ws/WOKMWSAuthenticate"


  body <- '<?xml version="1.0" encoding="UTF-8"?><SOAP-ENV:Envelope xmlns:ns0="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="http://auth.cxf.wokmws.thomsonreuters.com" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Header/><ns0:Body><ns1:authenticate/></ns0:Body></SOAP-ENV:Envelope>'


  h <- RCurl::basicTextGatherer()
  RCurl::curlPerform(
    url = url,
    httpheader = headers,
    postfields = body,
    writefunction = h$update
  )

  resp <- xml2::read_xml(h$value())
  sid <- xml2::xml_text(xml_find_first(resp, "//return"))

  sid
}

#' @export
#' @import xml2


wos_search <- function(sid, query = "") {

  body <- paste0('<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
  xmlns:woksearchlite="http://woksearchlite.v3.wokmws.thomsonreuters.com">
    <soapenv:Header/>
    <soapenv:Body>
    <woksearchlite:search>
    <queryParameters>
    <databaseId>WOS</databaseId>
    <userQuery>', query, '</userQuery>
    <editions>
    <collection>WOS</collection>
    <edition>SCI</edition>
    </editions>
    <queryLanguage>en</queryLanguage>
    </queryParameters>
    <retrieveParameters>
    <firstRecord>1</firstRecord>
    <count>5</count>
    </retrieveParameters>
    </woksearchlite:search>
    </soapenv:Body>
    </soapenv:Envelope>')

  url <- "http://search.webofknowledge.com/esti/wokmws/ws/WokSearchLite"
  headers <- c(
    Accept = "multipart/*",
    'Content-Type' = "text/xml; charset=utf-8",
    'Cookie' = paste0("SID=", sid),
    SOAPAction = ""
  )

  h <- RCurl::basicTextGatherer()
  RCurl::curlPerform(
    url = url,
    httpheader = headers,
    postfields = body,
    writefunction = h$update
  )

  resp <- xml2::read_xml(h$value())
  results <- as.numeric(xml_text(xml_find_first(resp, xpath = "//return/recordsFound")))
  query_id <- xml_text(xml_find_first(resp, xpath = "//return/queryId"))

  cat(paste0(results, " records found"))

  return(list(results = results, id = query_id))

}


#' @export

parse_wos_xml <- function(xml) {

  xpath <- "//records"
  records <- xml_find_all(xml, xpath = xpath)
  results <- list()
  i <- 0

  for (rec in records) {

    result <- list()

    ## Get UID
    xpath <- ".//uid"
    answer <- xml_text(xml_find_first(rec, xpath = xpath))
    result <- c(result, uid = answer)

    ## Get title
    xpath <- ".//title/label[text()='Title']/following-sibling::value"
    answer <- xml_text(xml_find_first(rec, xpath = xpath))
    result <- c(result, title = answer)

    i <- i + 1
    results[[i]] <- result


  }

  return(results)
}


#' @export
#' @import xml2

wos_retrieve <- function(sid, result, first = NULL, count = 100) {

  query_id <- result$id

  body <- paste0('<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
  <ns2:retrieve xmlns:ns2="http://woksearchlite.v3.wokmws.thomsonreuters.com">
    <queryId>', query_id, '</queryId>

    <retrieveParameters>
       <firstRecord>', first,'</firstRecord>
       <count>', count,'</count>
    </retrieveParameters>

  </ns2:retrieve>
  </soap:Body>
  </soap:Envelope>')

  url <- "http://search.webofknowledge.com/esti/wokmws/ws/WokSearchLite"
  headers <- c(
    Accept = "multipart/*",
    'Content-Type' = "text/xml; charset=utf-8",
    'Cookie' = paste0("SID=", sid),
    SOAPAction = ""
  )

  h <- RCurl::basicTextGatherer()
  RCurl::curlPerform(
    url = url,
    httpheader = headers,
    postfields = body,
    writefunction = h$update
  )

  xml <- xml2::read_xml(h$value())
  resp <- parse_wos_xml(xml)
  resp

}




#' @export
#' @import xml2
#' @importFrom dplyr bind_rows

wos_retrieve_all <- function(sid, result) {
  results <- result$results

  indices <- seq(1, results, 100)
  counts <- diff(indices)
  if (indices[length(indices)] != results) {
    counts <- c(counts, results - indices[length(indices)] + 1)
  }

  res <- list()
  for (i in seq_along(indices)) {
    cat("Retrieving ", indices[i], "-", indices[i] + counts[i] - 1, " of ", results, "\n", sep = "")
    res[[i]] <- dplyr::bind_rows(wos_retrieve(sid, result, first = indices[i], count = counts[i]))
  }

  dplyr::bind_rows(res)
}




