nasum <- function(x, simplify=TRUE)sapply(x,FUN=function(y)sum(is.na(y)),simplify=simplify)


