library(rwoslite)

sid <- wos_authenticate()

res <- wos_search(sid, "TS=computer")
publis <- wos_retrieve_all(sid, res)

res <- wos_search(sid, "AU=Wickham Hadley")

res <- wos_search(sid, "AU=Knuth Donald")
publis <- wos_retrieve_all(sid, res)

publis



