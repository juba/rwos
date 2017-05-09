wos_parse_records <- function(xml) {

  xpath <- "//records"
  records <- xml_find_all(xml, xpath = xpath)
  results <- list()
  i <- 0

  for (rec in records) {

    result <- list()

    ## UID
    xpath <- ".//uid"
    answer <- xml_text(xml_find_first(rec, xpath = xpath))
    result <- c(result, uid = answer)

    ## Article title
    xpath <- ".//title/label[text()='Title']/following-sibling::value"
    answer <- xml_text(xml_find_first(rec, xpath = xpath))
    result <- c(result, title = answer)

    ## Journal Name
    xpath <- ".//source/label[text()='SourceTitle']/following-sibling::value"
    answer <- xml_text(xml_find_first(rec, xpath = xpath))
    result <- c(result, journal = answer)

    ## Journal Issue
    xpath <- ".//source/label[text()='Issue']/following-sibling::value"
    answer <- xml_text(xml_find_first(rec, xpath = xpath))
    result <- c(result, issue = answer)

    ## Journal Volume
    xpath <- ".//source/label[text()='Volume']/following-sibling::value"
    answer <- xml_text(xml_find_first(rec, xpath = xpath))
    result <- c(result, volume = answer)

    ## Pages
    xpath <- ".//source/label[text()='Pages']/following-sibling::value"
    answer <- xml_text(xml_find_first(rec, xpath = xpath))
    result <- c(result, pages = answer)

    ## Date
    xpath <- ".//source/label[text()='Published.BiblioDate']/following-sibling::value"
    answer <- xml_text(xml_find_first(rec, xpath = xpath))
    result <- c(result, date = answer)

    ## Year
    xpath <- ".//source/label[text()='Published.BiblioYear']/following-sibling::value"
    answer <- xml_text(xml_find_first(rec, xpath = xpath))
    result <- c(result, year = answer)

    ## Authors
    xpath <- ".//authors/value"
    answer <- xml_text(xml_find_all(rec, xpath = xpath))
    result <- c(result, authors = paste(answer, collapse = " | "))

    ## Keywords
    xpath <- ".//keywords/value"
    answer <- xml_text(xml_find_all(rec, xpath = xpath))
    result <- c(result, keywords = paste(answer, collapse = " | "))

    ## DOI
    xpath <- ".//other/label[text()='Identifier.Doi']/following-sibling::value"
    answer <- xml_text(xml_find_first(rec, xpath = xpath))
    result <- c(result, doi = answer)

    ## Article number
    xpath <- ".//other/label[text()='Identifier.Article_no']/following-sibling::value"
    answer <- xml_text(xml_find_first(rec, xpath = xpath))
    result <- c(result, article_no = answer)

    ## ISI id
    xpath <- ".//other/label[text()='Identifier.Ids']/following-sibling::value"
    answer <- xml_text(xml_find_first(rec, xpath = xpath))
    result <- c(result, isi_id = answer)

    ## ISSN
    xpath <- ".//other/label[text()='Identifier.Issn']/following-sibling::value"
    answer <- xml_text(xml_find_first(rec, xpath = xpath))
    result <- c(result, issn = answer)

    ## ISBN
    xpath <- ".//other/label[text()='Identifier.Isbn']/following-sibling::value"
    answer <- xml_text(xml_find_first(rec, xpath = xpath))
    result <- c(result, isbn = answer)


    i <- i + 1
    results[[i]] <- result


  }

  return(results)
}
