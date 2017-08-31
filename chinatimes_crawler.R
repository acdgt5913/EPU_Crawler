#=====================================================
# 中國時報、工商時報、旺報爬蟲 v1.3 (2017/8/31)
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
setwd("/Users/jianjia/Dropbox/R/R_Workshop/EPU_TW")
source("FUNs.R")
source("FUN_chi_page.R")
source("FUN_chi_date.R")
source("FUN_chi_seq.R")
#=====================================================
# 備註
#=====================================================
# 1. np表示newspaper的種類：1為中時；2為工商：3為旺報
# 2. SQLite似乎無法支援R裡面的"Date"格式，即使SQLite裡面有DATE, DATETIME格式
# 所以必須以文字的方式存入！不然會變成REAL格式
#=====================================================
# 執行日誌！
#=====================================================
CT1.2012.1.1 <- chi.seq("2012-01-01", "2012-01-15", np = 1) # 76.22 mins
CT1.2012.1.2 <- chi.seq("2012-01-16", "2012-01-31", np = 1) # 39.03 mins
CT1.2012.2.1 <- chi.seq("2012-02-01", "2012-02-15", np = 1) # 76.02 mins
CT1.2012.2.2 <- chi.seq("2012-02-16", "2012-02-29", np = 1) # 52.45 mins (2012年為閏年)
CT1.2012.3.1 <- chi.seq("2012-03-01", "2012-03-15", np = 1) # 60.4 mins
CT1.2012.3.2 <- chi.seq("2012-03-16", "2012-03-31", np = 1) # 88.38 mins
CT1.2012.4.1 <- chi.seq("2012-04-01", "2012-04-15", np = 1) # 25.4 mins
CT1.2012.4.2 <- chi.seq("2012-04-16", "2012-04-30", np = 1) # 29.79 mins
CT1.2012.5 <- chi.seq("2012-05-01", "2012-05-31", np = 1) # 98.81 mins
CT1.2012.6 <- chi.seq("2012-06-01", "2012-06-30", np = 1) # 72.54 mins
CT1.2012.7 <- chi.seq("2012-07-01", "2012-07-31", np = 1) # 74.37 mins
CT1.2012.8 <- chi.seq("2012-08-01", "2012-08-31", np = 1) # 79.35 mins
CT1.2012.9 <- chi.month(2012, 9, np = 1) # 162.4 mins
#=====================================================
# SQLite import
#=====================================================
drv <- dbDriver("SQLite")
db = dbConnect(drv, dbname = "/Users/jianjia/Dropbox/R/R_Workshop/EPU_TW/Database/china.times.db")
dbWriteTable(db, "All.articles", CT1.2012.1.1, append = T) # 08-23
dbWriteTable(db, "All.articles", CT1.2012.1.2, append = T)
dbWriteTable(db, "All.articles", CT1.2012.2.1, append = T) 
dbWriteTable(db, "All.articles", CT1.2012.2.2, append = T) # 08-24
dbWriteTable(db, "All.articles", CT1.2012.3.1, append = T) 
dbWriteTable(db, "All.articles", CT1.2012.3.2, append = T) # 08-25
dbWriteTable(db, "All.articles", CT1.2012.4.1, append = T) 
dbWriteTable(db, "All.articles", CT1.2012.4.2, append = T) # 08-26
dbWriteTable(db, "All.articles", CT1.2012.5, append = T) 
dbWriteTable(db, "All.articles", CT1.2012.6, append = T)
dbWriteTable(db, "All.articles", CT1.2012.7, append = T)
dbWriteTable(db, "All.articles", CT1.2012.8, append = T) # 08-27
dbWriteTable(db, "All.articles", CT1.2012.9, append = T) # 08-31


#=====================================================
# SQLite useage (Examples, Not run)
#=====================================================
drv <- dbDriver("SQLite")
db = dbConnect(drv, dbname = "/Users/jianjia/Dropbox/R/R_Workshop/EPU_TW/Database/china.times.db")
# get a list of all tables
dbListTables(db)
# disconnect the database
dbDisconnect(db)
# save dataframe into the database
dbWriteTable(db, "All.articles", data, overwrite = T)
# append 的功能就是可以接續下去存取，也就是rbind
dbWriteTable(db, "All.articles", data, append = T)
# read the table you want
All.articles <- dbReadTable(db, "All.articles")
# remove the table
dbRemoveTable(db, "All.articles")