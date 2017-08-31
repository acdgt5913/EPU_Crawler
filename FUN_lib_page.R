#=====================================================
# 函數1：抓一個page(category)所有的文章 v1.2 (08-29)
# 08-28：修正有文章的連結出現錯誤的問題(沒有標題的文章)，應該是自由網頁設計的bug
#=====================================================
lib.page <- function(date, category, verbose = FALSE) {
  time.start <- Sys.time()
  # 一些參數設定
  len = length
  ltn <- "http://news.ltn.com.tw"
  c <- switch(as.character(category),
              "1" = "focus", "2" = "politics",
              "3" = "society", "4" = "world", "5" = "business")
  d <- str_replace_all(date, "-", "")
  # 處理文章內容的函數
  article.paste.lib <- function(x, pattern) {
    n <- len(x)
    for(i in 1:n) {
      if(i == 1) {
        article <- x[i]
      } else {
        if(!any(str_detect(x[i], pattern))) {
          article <- paste0(article, x[i])
        } else next
      }
    }
    return(article)
  }
  # 第一頁的連結，先取得總頁數
  doc.origin <- read_html(paste(ltn, "list/newspaper", c, d, sep = "/"))
  # 檢視頁數 (08/28加入)
  page <- doc.origin %>%
    html_nodes(".p_last") %>%
    html_attr("href")
  page <- ifelse(len(page) != 0, str_sub(page, str_count(page)) %>% as.numeric(), 1)
  for(p in 1:page) {
    if(p == 1) {
      doc.p <- doc.origin
    } else {
      doc.p <- read_html(paste(ltn, "list/newspaper", c, d, p, sep = "/"))
    }
    article.list <- doc.p %>%
      html_nodes("div.whitecon.boxTitle") %>%
      html_nodes("li") %>%
      html_nodes("a.tit") %>%
      html_attr("href")
    article.title <- doc.p %>%
      html_nodes("div.whitecon.boxTitle") %>%
      html_nodes("li") %>%
      html_nodes("a.tit") %>%
      html_text() %>%
      str_trim()
    if(len(article.list) != 0) {
      article.df <- data.frame(link = article.list, 
                               title = ifelse(article.title == "", NA, article.title)) %>%
        na.omit
      for(i in 1:nrow(article.df)) {
        doc.a <- read_html(paste0(ltn, article.df$link[i]))
        # 本文
        content <- doc.a %>%
          html_nodes("div.text") %>%
          html_nodes("p") %>%
          html_text()
        # 爬取圖片敘述，因為文章內容會誤抓要再刪除
        pic <- doc.a %>%
          html_nodes("div.text") %>%
          html_nodes("ul") %>%
          html_nodes("p") %>%
          html_text()
        article <- article.paste.lib(content, pic) # 合併所有段落並且刪除圖片敘述
        if(str_detect(article, "記者") | str_detect(article, "編譯")) {
          s <- na.omit(str_locate(article, "記者")[1], str_locate(article, "編譯")[1])
          e <- na.omit(str_locate(article, "╱")[1], str_locate(article, "／")[1])
          rp_name <- str_sub(article, s+2, e-1)
          if(!is.na(rp_name)) {
            if(str_detect(article, "〔" & str_detect(article, "〕"))) {
              a <- str_locate(article, "〔")[1]
              b <- str_locate(article, "〕")[1]
              article <- str_replace(article, str_sub(article, a, b), "")
            } else {
              if(str_detect(article, "報導")) {
                z <- str_locate(article, "報導")[2]
                article <- str_replace(article, str_sub(article, s, z), "")
              } else {
                article <- str_replace(article, str_sub(article, s, e), "")
              }
            }
            reporter <- rp_name
          } else {
            reporter <- NA
          }
        } else {
          reporter <- NA
        }
        # 合併所有變數
        if(i == 1) {
          article.p <- data.frame(date = date, reporter = reporter, 
                                    category = c, title = article.df$title[i],
                                    content = article)
        } else {
          article.p <- rbind.data.frame(article.p,
                                          data.frame(date = date, reporter = reporter, 
                                                     category = c, 
                                                     title = article.df$title[i],
                                                     content = article))
        }
        Sys.sleep(sample(2:4, 1)) # 休息2~4秒以免被ban
      }
      if(p == 1) {
        article.all <- article.p
      } else {
        article.all <- rbind.data.frame(article.all, article.p)
      }
    } else {
      article.all <- character(0)
    }
  }
  if(verbose) {
    time.interval <- time_length(interval(time.start, Sys.time()), unit = "min") %>% round(2)
    print(paste("Function execution time: ", time.interval, "mins", sep = " "))
  }
  return(article.all)
}
