library(rwos)

sid <- wos_authenticate()
sid

sq <- wos_search(sid, "TS=(soil AND health)")
sq <- wos_search(sid, "TS=(soil SAME quality)")
sq <- wos_search(sid, 'TS="soil health"')
sq <- wos_search(sid, "TS=\"soil quality\"")

sq <- wos_search(sid, 'TS="soil quality"')

sq <- wos_search(sid, "((TS=(soil AND health)) AND (DT=(Article OR Book OR Book Chapter)))")

res <- wos_search(sid, "TS=computer")
publis <- wos_retrieve_all(res)

res <- wos_search(sid, "AU=Pierre Merckle")
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


res <- wos_search(sid, "AU=Buhlmann F")
publis <- wos_retrieve_all(res)
publis
View(publis)

res <- wos_search(sid, "TS=développement")
res <- wos_search(sid, "TS=developpement")


res <- wos_search(sid, "CU=Latvia")
res <- wos_search(sid, "CU=Latvia", editions = "SCI")   # Ok
res <- wos_search(sid, "CU=Latvia", editions = "SSCI")  # NO
res <- wos_search(sid, "CU=Latvia", editions = "AHCI")  # NO
res <- wos_search(sid, "CU=Latvia", editions = "ISTP")  # Ok
res <- wos_search(sid, "CU=Latvia", editions = "ISSHP") # Ok
res <- wos_search(sid, "CU=Latvia", editions = "IC")    # Ok
res <- wos_search(sid, "CU=Latvia", editions = "CCR")   # NO
res <- wos_search(sid, "CU=Latvia", editions = "BSCI")  # NO
res <- wos_search(sid, "CU=Latvia", editions = "BHCI")  # NO
res <- wos_search(sid, "CU=Latvia", editions = "ESCI")  # NO
