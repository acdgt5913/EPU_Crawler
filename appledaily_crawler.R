#=====================================================
# 蘋果Daily v0.2 (2017/8/26)
#=====================================================
# required packages
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
#rm(list = ls())
setwd("/Users/jianjia/Dropbox/R/R_Workshop/EPU_TW")
source("FUNs.R")
source("FUN_app_date.R")
source("FUN_app_seq.R")
# Note: 最早到 "2003-05-02"
#=====================================================
# 執行日誌！
#=====================================================
AP.2003.5.1 <- app.date("2003-05-02", verbose = T)
AP.2003.5.2 <- app.seq("2003-05-03", "2003-05-05")
AP.2003.8.1 <- app.seq("2003-08-01", "2003-08-15")
AP.2003.8.2 <- app.seq("2003-08-16", "2003-08-31")
#=====================================================
# SQLite import
#=====================================================
drv <- dbDriver("SQLite")
db = dbConnect(drv, dbname = "/Users/jianjia/Dropbox/R/R_Workshop/EPU_TW/Database/apple.daily.db")
dbWriteTable(db, "All.articles", AP.2003.5.1, overwrite = T) # 08-27



