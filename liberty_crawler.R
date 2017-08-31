#=====================================================
# 自由時報 v1.2 (2017/8/29)
#=====================================================
library(httr)
library(rvest)
library(lubridate)
library(dplyr)
library(stringr)
library(RSQLite)
library(progress)
# environment setting
options(stringsAsFactors = F)
len = length
setwd("/Users/jianjia/Dropbox/R/R_Workshop/EPU_TW")
source("FUN_lib_date.R")
source("FUN_lib_seq.R")
# Note: 最早到 "2005-01-01"
#=====================================================
# 執行日誌！
#=====================================================
LT.2005.1 <- lib.month(2005, 1) # 119.36 mins
LT.2005.1.1 <- lib.seq("2005-01-01", "2005-01-15") # 14.16 mins
LT.2005.1.2 <- lib.seq("2005-01-16", "2005-01-31") #
LT.2005.2.1 <- lib.seq("2005-02-01", "2005-02-15") # 10.98 mins
LT.2005.2.2 <- lib.seq("2005-02-16", "2005-02-28") # 11.3 mins
LT.2005.3.1 <- lib.seq("2005-03-01", "2005-03-15") # 13.78 mins
LT.2005.3.2 <- lib.seq("2005-03-16", "2005-03-31") # 14.61 mins
LT.2005.4 <- lib.seq("2005-04-01", "2005-04-30")
LT.2005.5 <- lib.seq("2005-05-01", "2005-05-31")
LT.2005.6 <- lib.seq("2005-06-01", "2005-06-30")
#=====================================================
# SQLite import
#=====================================================
drv <- dbDriver("SQLite")
db = dbConnect(drv, dbname = "/Users/jianjia/Dropbox/R/R_Workshop/EPU_TW/Database/liberty.times.db")
dbWriteTable(db, "All.articles", LT.2005.1, overwrite = T) # 08-26
LT.2005.1$date <- as.character(LT.2005.1$date)
class(LT.2005.1$date)
