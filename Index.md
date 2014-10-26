---
title       : Data products assignment, coursera
subtitle    : Analyze NOAA storm data
author      : Ratnasri Maddala
job         : Consultant
framework   : io2012        # {io2012, html5slides, shower, dzslides, ...}
highlighter : highlight.js  # {highlight.js, prettify, highlight}
hitheme     : tomorrow      # 
widgets     : [bootstrap]            # {mathjax, quiz, bootstrap}
mode        : selfcontained # {standalone, draft}
knit        : slidify::knit2slides
---
## Introduction
This shiny application allows user to analyze the event types that cause maximum damage to the health and property in the United States of America.
Data between 1950 and 2011 is avaliable, covering human fatalities, injuries, property damage and damage to the crops.

Data is obtained from an assignment on coursera's [Reproducible Research course](https://class.coursera.org/repdata-007/human_grading/view/courses/972596/assessments/4/submissions). Latest data is available at the [original source](http://www.ncdc.noaa.gov/IPS/sd/sd.html).

--- 
## Process overview  
### Data preparation  
1. Extracted year from BGN_YEAR  
2. Converted property and crop damage to actual numbers from exponents  
3. Discarded unwanted columns  
4. Grouped data using year, event type, county and summed up the damage data  

### Data on the website  
1. Top ten event types that had caused maximum damage were plotted
2. Damage data for Fatalities since the year 2000 is shown by default
3. Use may change the time frame or the damage type

The [applicaion](http://ratna.shinyapps.io/project-006) is hosted on Shiny server. Source code is available on [github](http://github.com/ratnasri/DataProduct_Coursera)  

```{ r dataPreparation, echo=FALSE, results=HIDE, cache=TRUE}
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
```  

--- 

## Results

```
## Using EVTYPE as id variables
```

![plot of chunk ShowResults](assets/fig/ShowResults.png) 

--- 
## Conclusion
1. Tornados and Floods are causing maximum loss
2. Allocating funds to handle these two event types seems to the optimum solution.
