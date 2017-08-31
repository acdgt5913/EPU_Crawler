#=====================================================
# 函數1：抓一天date所有的文章 v0.2
#=====================================================
app.date <- function(date, verbose = FALSE) {
  time.start <- Sys.time()
  len = length
  d <- str_replace_all(date, "-", "")
  url <- paste0("http://www.appledaily.com.tw/appledaily/archive/", d)
  doc <- read_html(url)
  article.list <- doc %>% 
    html_nodes(xpath = "//*[@id='coverstory']/div[2]") %>%
    html_nodes("article") %>%
    html_nodes("a") %>%
    html_attr("href")
  article.title <- doc %>%
    html_nodes(xpath = "//*[@id='coverstory']/div[2]") %>%
    html_nodes("article") %>%
    html_nodes("a") %>%
    html_text()
  category <- str_split(article.list, "/", n = 5, simplify = F)
  for(c in 1:len(category)) {
    if(c == 1) {
      article.type <- category[[c]][4]
    } else {
      article.type <- append(article.type, category[[c]][4])
    }
  }
  if(len(article.list) != 0) {
    article.df <- data.frame(link = article.list, title = article.title, category = article.type)
    article.df <- subset(article.df, category %in% c("headline","international","finance"))
    if(verbose) {
      pb <- progress_bar$new(
        format = "No: :what [:bar] :percent ,duration: :elapsed",
        clear = FALSE, total = nrow(article.df), width = 60)
    }
    for(i in 1:len(article.df$link)) {
      if(verbose) {
        pb$tick(tokens = list(what = i))
      }
      url.a <- paste0("http://www.appledaily.com.tw", article.df$link[i])
      doc.a <- read_html(url.a)
      # 本文
      content  <- doc.a %>% 
        html_nodes("article") %>%
        html_nodes("div") %>%
        html_nodes("p") %>%
        html_text() %>%
        str_trim()
      article <- article.paste(content)
      # 記者
      if(str_detect(article, "】")) {
        start <- str_locate(article, "【")[1]
        end <- str_locate(article, "】")[1]
        rp_name <- str_sub(article, start+1, end-1)
        article <- str_replace(article, str_sub(article, start, end), "")
        if(str_detect(rp_name, "╱")) {
          reporter <- str_split(rp_name, "╱", simplify = T)[1]
        } else if(str_detect(rp_name, "／")) {
          reporter <- str_split(rp_name, "／", simplify = T)[1]
        } else {
          reporter <- rp_name
        }
      } else {
        reporter <- NA
      }
      # 合併所有變數
      if(i == 1) {
        article.all <- data.frame(date = date, reporter = reporter, 
                                  category = article.df$category[i], title = article.df$title[i],
                                  content = article)
      } else {
        article.all <- rbind.data.frame(article.all,
                                        data.frame(date = date, reporter = reporter, 
                                                   category = article.df$category[i], title = article.df$title[i],
                                                   content = article))
      }
      Sys.sleep(sample(2:4, 1)) # 隨機休息2~4秒，避免被ban
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

