setwd("//pin.local/Data Center/Redirect/areed/My Documents/NEIEN/TGG/RCalls/2020-05-05")

library(readxl)
library(tidyverse)
library(lubridate)
library(dplyr)

#LET'S IMPORT THE CSV FILE USING THE GUI MENUS


#WHAT HAPPENS WHEN WE JUST USE THIS COMMAND?
MLO_365_10756015_20180705 <- read_csv("../PINTempData/MLO_365_10756015_20180705.csv")


MLO_365_10756015_20180705 <- read_csv("../PINTempData/MLO_365_10756015_20180705.csv", 
                                      col_names = FALSE, skip = 2)

#LET'S GET SOME INFO FROM THE NAME OF THE DATAFRAME THAT COMES FROM THE CSV FILENAME
#THIS IS POSSIBLE BECAUSE WE ARE USING A SPECIFIC & CONSISTENT NAMING SCHEME

#CREATE AN OBJECT THAT CONTAINS THE NAME
dfname <- deparse(substitute(MLO_365_10756015_20180705))

#GETS THE FOURTH SECTION OF THE STRING SEPARATED BY UNDERSCORES
#WHICH IS THE DATE THAT THIS FILE WAS DOWNLOADED FROM THE UNIT
DLdate <- str_split(dfname, "_")[[1]][4]

#GETS THE FIRST SECTION OF THE STRING SEPARATED BY UNDERSCORES
#WHICH IS THE NAME OF THE SITE
SiteName <- str_split(dfname, "_")[[1]][1]

#MAKE A DATAFRAME THAT HAS A SHORTER NAME
MLO_365 <- MLO_365_10756015_20180705


MLO_365 <- MLO_365 %>% 
  select("X2", "X3") %>% #USE ONLY CERTAIN COLUMNS
  rename("datetime" = X2,
       "temporig" = X3) %>% #GIVE THE COLUMNS PARTICULAR NAMES
  mutate(datetime = mdy_hms(datetime),site = SiteName) #CHANGE THE CLASS OF FORMAT THE DATE TIME COLUMN

#LET'S CHECK THE CLASS OF THE DATE TIME COLUMN
class(MLO_365$datetime)

#READ IN THE FILE IN WHICH WE ARE KEEPING RECORD OF INFORMATION ABOUT EACH SITE'S DATA
LDRTimes <- read_excel("../PINTempData/PIN_MattamiscontisSites_LDRTimes.xlsx",
                       col_types = c("text", "numeric", "numeric","numeric", 
                                     "date", "date", "date","numeric"))

#FILTER OUT THE RECORD THAT MATCHES CERTAIN CRITERIA COMING FROM THE FILENAME
LDRTimesF <- LDRTimes %>% 
  filter(site == SiteName & data_files == DLdate)

#SELECT ONLY CERTAIN COLUMNS FROM THE LDR FILE
SiteInfo <- LDRTimesF %>% 
  select("site", "latitude", "longitude", "unit_sn")

#ADD THE SITEINFO DATA TO THE RAW DATA BY JOINING THE TABLES
MLO_365 <- left_join(MLO_365,SiteInfo,by = "site")

#GET INFORMATION ABOUT THE UNIT'S LAST DEPLOYMENT
launch = LDRTimesF$launch_time
deploy = LDRTimesF$deploy_time
retrieve = LDRTimesF$retrieval_time

#CLIP THE DATA BETWEEN THE TIME IT WAS DEPLOYED AND RETRIEVED
MLO_365_Clip = filter(MLO_365, between(datetime, deploy, retrieve))



