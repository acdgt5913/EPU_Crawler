#=====================================================
# FUNs
#=====================================================
article.paste <- function(x) {
  len = length
  n <- len(x)
  for(i in 1:n) {
    if(i == 1) {
      article <- x[i]
    } else {
      article <- paste0(article, x[i])
    }
  }
  return(article)
}
