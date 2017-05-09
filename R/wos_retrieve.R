
#' @import xml2

wos_retrieve_page <- function(sid, result, first = NULL, count = 100) {

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
  resp <- wos_parse_records(xml)
  resp

}


#' @export
#' @importFrom dplyr bind_rows

wos_retrieve <- function(sid, result, first = NULL, number = 100) {

  indices <- seq(first, number, 100)
  counts <- diff(indices)
  if (indices[length(indices)] != number) {
    counts <- c(counts, number - indices[length(indices)] + 1)
  }

  res <- list()
  for (i in seq_along(indices)) {
    cat("Retrieving ", indices[i], "-", indices[i] + counts[i] - 1, " of ", number, "\n", sep = "")
    res[[i]] <- dplyr::bind_rows(wos_retrieve_page(sid, result, first = indices[i], count = counts[i]))
  }

  dplyr::bind_rows(res)

}


#' @export

wos_retrieve_all <- function(sid, result) {

  wos_retrieve(sid, result, first = 1, number = result$results)

}




