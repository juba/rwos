library(rwos)

sid <- wos_authenticate()
sid

res <- wos_search(sid, "TS=computer")
publis <- wos_retrieve_all(res)

res <- wos_search(sid, "AU=Wickham Hadley")
publis <- wos_retrieve_all(res)
publis
View(publis)

publis <- wos_retrieve(res, first = 10, count = 10)
publis
View(publis)


res <- wos_search(sid, "AU=Knuth Donald")
publis <- wos_retrieve_all(res)
publis
View(publis)

res <- wos_search(sid, "CU=Latvia")
publis <- wos_retrieve_all(res)
publis
View(publis)
publis <- wos_retrieve(res, first = 11000, count = 800)
publis <- wos_retrieve(res, first = 10, count = 10)

publis



