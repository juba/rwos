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

