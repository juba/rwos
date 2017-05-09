
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

