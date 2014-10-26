setwd('/Users/ratnasri/Desktop/Ratna/DS2014_Ratna/dataprod')
raw_data <- read.csv("stormData.bz2",stringsAsFactors=FALSE)
dim(raw_data)
storm_data <- raw_data[,c(2,5,6,7,8,23,24,25,26,27,28)]
storm_data$BGN_YEAR <- sapply(1:nrow(storm_data),
                     function(x){ ifelse(is.na(x),NA,
                                    as.numeric(unlist(strsplit(unlist(
                       strsplit(storm_data$BGN_DATE[x],' '))[1],'/'))[3]))})
#Economic loss data preparation
#preprocess data to convert loss into corresponding  numbers
pattern <- c("^$|[-?+]", "[hH]", "[kK]", "[mM]", "[bB]")
replacement <-c("0", "2", "3", "6", "9")
for (i in 1:length(pattern)) {
  storm_data$PROPDMGEXP <- sub(pattern[i],replacement[i], storm_data$PROPDMGEXP)
  storm_data$CROPDMGEXP <- sub(pattern[i],replacement[i], storm_data$CROPDMGEXP)
}

#Convert to actual numbers
storm_data$PROPDMGEXP <- 10^as.numeric(storm_data$PROPDMGEXP)
storm_data$PROPDMG <- as.numeric(storm_data$PROPDMG)*storm_data$PROPDMGEXP
storm_data$CROPDMGEXP <- 10^as.numeric(storm_data$CROPDMGEXP)
storm_data$CROPDMG <- as.numeric(storm_data$CROPDMG) * storm_data$CROPDMGEXP

#Remove unwanted columns
storm_data <- storm_data[,c(2,3,4,5,6,7,8,10,12)]
library(plyr)
groupColumns <-  c("BGN_YEAR","EVTYPE","COUNTY","COUNTYNAME","STATE")
dataColumns <- c("FATALITIES","INJURIES","PROPDMG","CROPDMG")
storm_data <-  ddply(storm_data,groupcolumns,function(x) colSums(x[datacolumns]))
storm_data <- storm_data[!(storm_data$FATALITIES==0 & storm_data$INJURIES==0 &
                             storm_data$PROPDMG==0 & storm_data$CROPDMG ==0),]
write.table(storm_data,file="storm_data.csv",sep=",")