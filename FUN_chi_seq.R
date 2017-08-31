#=====================================================
# 函數3：抓多個date的文章 -> 最早到2009-09-28
#=====================================================
chi.seq <- function(start, end, np = 1) {
  time.start <- Sys.time()
  len = length
  seq.date <- as.character(seq.Date(ymd(start), ymd(end), by = "day"))
  pb <- progress_bar$new(
    format = "Date: :what [:bar] :percent ,duration: :elapsed",
    clear = FALSE, total = len(seq.date), width = 60)
  for(d in 1:len(seq.date)) {
    pb$tick(tokens = list(what = seq.date[d]))
    article <- chi.date(date = seq.date[d], np = np)
    if(len(article) != 0) {
      if(d == 1) {
        article.all <- article
      } else {
        article.all <- rbind.data.frame(article.all, article)
      }
    } else next
  }
  time.interval <- time_length(interval(time.start, Sys.time()), unit = "min") %>% round(2)
  cat("Required articles are downloaded! Execution time: ", time.interval, "mins", "\n")
  return(article.all)
}
#=====================================================
# 函數4：抓取指定年月份的文章 -> 最早到2009-09-28
#=====================================================
chi.month <- function(year, month, ...) {
  time.start <- Sys.time()
  len = length
  start <- ymd(year * 10^4 + month * 10^2 + 1)
  end <- ceiling_date(start, unit = "month") - 1
  seq.date <- as.character(seq.Date(start, end, by = "day"))
  pb <- progress_bar$new(
    format = "Downloading article on :what [:bar] :percent in :elapsed",
    clear = FALSE, total = len(seq.date), width = 60)
  for(d in 1:len(seq.date)) {
    pb$tick(tokens = list(what = seq.date[d]))
    article <- chi.date(date = seq.date[d], verbose = F, ...)
    if(len(article) != 0) {
      if(d == 1) {
        article.all <- article
      } else {
        article.all <- rbind.data.frame(article.all, article)
      }
    } else next
  }
  time.interval <- time_length(interval(time.start, Sys.time()), unit = "min") %>% round(2)
  cat("Required articles are downloaded! Execution time: ",time.interval, "mins", "\n")
  return(article.all)
}
