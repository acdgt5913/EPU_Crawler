#=====================================================
# 函數2：抓一個date所有的文章 -> 最早到2009-09-28
#=====================================================
chi.date <- function(date, np = 1, verbose = FALSE) {
  time.start <- Sys.time()
  len = length
  url <- paste0("http://www.chinatimes.com/history-by-date/", date, "-260", np)
  doc <- read_html(url)
  # page1 first!
  url.p1 <- paste0(url, "?page=", 1)
  article.all <- chi.page(url = url.p1)
  if(len(article.all) != 0) {
    for(page in 2:100) {
      url.p <- paste0(url, "?page=", page)
      article.p <- chi.page(url = url.p)
      # 若該頁沒有東西，則chi.page函數會回傳character(0)，迴圈就會停止
      if(len(article.p) != 0) {
        article.all <- rbind.data.frame(article.all, article.p)
      } else break
    }
  } else {
    article.all <- character(0)
  }
  if(verbose) {
    time.interval <- time_length(interval(time.start, Sys.time()), unit = "min") %>% round(2)
    cat("Required articles are downloaded! Execution time: ", time.interval, "mins", "\n")
  }
  return(article.all)
}