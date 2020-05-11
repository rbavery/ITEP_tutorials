library(dataRetrieval)

#THIS IS FOR WEST ENFIELD GAUGE STATION
siteNo <- "01034500"

# this pcode is for discharge in cfs
#For a full list of pCodes see #https://help.waterdata.usgs.gov/code/parameter_cd_query?fmt=rdb&inline=true&group_cd=%
pCode <- "00060"

start.date <- "2019-01-01"
end.date <- "2020-01-14"

WEnfieldcfs <- readNWISuv(siteNumbers = siteNo,
                          parameterCd = pCode,
                          startDate = start.date,
                          endDate = end.date)

WEnfieldcfs <- renameNWISColumns(WEnfieldcfs)
names(WEnfieldcfs)

library(ggplot2)
ts <- ggplot(data = WEnfieldcfs,
             aes(dateTime, Flow_Inst)) +
  geom_line()
ts


parameterInfo <- attr(WEnfieldcfs, "variableInfo")
siteInfo <- attr(WEnfieldcfs, "siteInfo")

ts <- ts +
  xlab("") +
  ylab(parameterInfo$variableDescription) +
  ggtitle(siteInfo$station_nm)
ts



