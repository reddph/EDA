setwd("./ExploratoryDataAnalysis/")
unzip("./exdata_data_household_power_consumption.zip")

household_power_consumption <- read.csv("~/R_Practice/ExploratoryDataAnalysis/household_power_consumption.txt", sep=";", na.strings="?")

#Only data between 2007-02-01 and 2007-02-02 is used

library(lubridate)
library(dplyr)
library(png)

names(household_power_consumption)
summary(household_power_consumption)

household_power_consumption <- mutate(household_power_consumption,DMY=dmy(Date))

filtHPC <- filter(household_power_consumption, year(DMY) == 2007 & month(DMY) == 2 & day(DMY) %in% c(1,2))

filtHPC <- mutate(filtHPC, WDAY=wday(DMY))
tbase <- 1:length(filtHPC$Time)

png(filename="plot2.png", width=480, height=480, units="px")

plot(tbase, filtHPC$Global_active_power, ylab="Global Active Power (kilowatts)", type='l', xaxt="n", xlab="")
axis(1, c(1,1439,2879), c("Thu","Fri","Sat"))

dev.off() 