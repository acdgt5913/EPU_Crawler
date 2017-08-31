#=====================================================
# 函數1：抓一個page所有的文章 v1.0
#=====================================================
chi.page <- function(url) {
  doc.origin <- read_html(url, encoding = "UTF-8")
  article.list <- doc.origin %>%
    html_nodes("div.listRight") %>%
    html_nodes("h2") %>%
    html_nodes("a") %>%
    html_attr("href")
  article.title <- doc.origin %>%
    html_nodes("div.listRight") %>%
    html_nodes("h2") %>%
    html_nodes("a") %>%
    html_text() %>% 
    str_trim
  article.type <- doc.origin %>%
    html_nodes("div.listRight") %>%
    html_nodes(".kindOf") %>%
    html_text() %>% 
    str_trim
  if(length(article.list) != 0) {
    for(i in 1:length(article.list)) {
      url.a <- paste0("http://www.chinatimes.com", article.list[i])
      doc <- read_html(url.a)
      # 日期、時間
      datetime <- doc %>%
        html_nodes(xpath = "//*[@id='page']/div[2]/div[3]/article/div[2]/div[1]/time") %>%
        html_text()
      datetime <- str_split(datetime, " ", simplify = T)
      date <- datetime[1] %>%
        str_replace("年", "-") %>%
        str_replace("月", "-") %>%
        str_replace("日", "")
      time <- datetime[2]
      # 記者
      rp_name <- doc %>%
        html_nodes(xpath = "//*[@id='page']/div[2]/div[3]/article/div[2]/div[1]/div") %>%
        html_text()
      reporter <- ifelse(str_detect(rp_name, "／"), 
                         str_split(rp_name, "／", simplify = T)[1],
                         rp_name)
      # 本文
      temp <- doc %>% html_nodes("article.clear-fix") %>%
        html_nodes("p") %>%
        html_text()
      # 文章最後一段是來源
      source <- temp[length(temp)]
      # 去掉來源
      content <- temp[-length(temp)]
      article <- article.paste(content)
      # 合併所有變數
      if(i == 1) {
        article.all <- data.frame(date = date, reporter = reporter, 
                                  category = article.type[i], title = article.title[i],
                                  content = article)
      } else {
        article.all <- rbind.data.frame(article.all,
                                        data.frame(date = date, reporter = reporter, 
                                                   category = article.type[i], 
                                                   title = article.title[i],
                                                   content = article))
      }
    }
  } else {
    article.all <- character(0)
  }
  return(article.all)
}